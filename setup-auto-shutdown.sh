#!/bin/bash

# Auto-shutdown Setup Script for macOS
# This script sets up automatic shutdown after 30 minutes of inactivity
# Author: Auto-generated for Caleb Sargeant
# Usage: ./setup-auto-shutdown.sh [install|uninstall|status]

set -e  # Exit on any error

# Configuration
SCRIPT_NAME="auto-shutdown-idle.sh"
SERVICE_NAME="com.sargeant.auto-shutdown-idle"
IDLE_THRESHOLD=1800  # 30 minutes in seconds
CHECK_INTERVAL=60    # Check every 60 seconds

# Paths
SCRIPT_DIR="$HOME/Library/Scripts"
SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"
PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"
SUDOERS_PATH="/etc/sudoers.d/auto-shutdown-idle"
LOG_DIR="$HOME/Library/Logs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root. Run as your regular user."
        exit 1
    fi
}

# Function to create the monitoring script
create_monitoring_script() {
    print_status "Creating monitoring script at $SCRIPT_PATH"
    
    mkdir -p "$SCRIPT_DIR"
    
    cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

# Auto-shutdown script for macOS - GRACEFUL SHUTDOWN VERSION
# Monitors system idle time and gracefully shuts down after 30 minutes of inactivity
# Gives applications time to close properly - Use 'caffeinate' if you need to prevent shutdown

# Configuration
IDLE_THRESHOLD=1800  # 30 minutes in seconds
CHECK_INTERVAL=60    # Check every 60 seconds
LOG_FILE="$HOME/Library/Logs/auto-shutdown-idle.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Function to get system idle time in seconds
get_idle_time() {
    # Get idle time from IOHIDSystem
    local idle_ns=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF}')
    if [[ -n "$idle_ns" ]]; then
        # Convert nanoseconds to seconds
        echo $((idle_ns / 1000000000))
    else
        echo 0
    fi
}

# Function to perform graceful but forced shutdown
perform_shutdown() {
    log_message "GRACEFUL SHUTDOWN: System has been idle for $IDLE_THRESHOLD seconds. Initiating shutdown sequence."
    
    # Send notification with more time for users to react
    if command -v osascript > /dev/null 2>&1; then
        osascript -e 'display notification "SHUTDOWN due to inactivity in 30 seconds - Use caffeinate to prevent" with title "Auto Shutdown" sound name "Glass"' 2>/dev/null || true
    fi
    
    # Log the 30-second warning
    log_message "WARNING: Shutdown in 30 seconds. Applications will be given time to close gracefully."
    
    # Give users 30 seconds to react (save work, prevent with caffeinate, etc.)
    sleep 30
    
    # Check one more time if system is still idle (user might have become active)
    current_idle=$(get_idle_time)
    if [[ $current_idle -lt 60 ]]; then
        log_message "SHUTDOWN CANCELLED: User became active (idle time: $current_idle seconds)"
        return
    fi
    
    # Graceful shutdown with 1 minute delay - gives apps time to close properly
    # This sends SIGTERM first, then SIGKILL after system default interval
    log_message "EXECUTING SHUTDOWN: Graceful shutdown initiated with 1 minute delay for app cleanup"
    sudo /sbin/shutdown -h +1 "System shutting down due to inactivity. Applications will be closed gracefully."
}

# Main loop
main() {
    log_message "Auto-shutdown service started (PID: $$) - GRACEFUL SHUTDOWN MODE"
    log_message "Idle threshold: $IDLE_THRESHOLD seconds ($((IDLE_THRESHOLD/60)) minutes)"
    log_message "Check interval: $CHECK_INTERVAL seconds"
    log_message "INFO: This will gracefully shutdown, giving applications time to close properly"
    log_message "Use 'caffeinate -d' to prevent shutdown when needed"
    
    while true; do
        idle_time=$(get_idle_time)
        
        if [[ $idle_time -ge $IDLE_THRESHOLD ]]; then
            log_message "System idle for $idle_time seconds - INITIATING GRACEFUL SHUTDOWN"
            perform_shutdown
            break
        else
            # Only log every 5 minutes to avoid spam
            if [[ $((idle_time % 300)) -eq 0 ]] && [[ $idle_time -gt 0 ]]; then
                log_message "System idle for $idle_time seconds (will force shutdown at $IDLE_THRESHOLD)"
            fi
        fi
        
        sleep $CHECK_INTERVAL
    done
}

# Handle signals gracefully
trap 'log_message "Auto-shutdown service stopped (PID: $$)"; exit 0' TERM INT

# Start the main loop
main "$@"
EOF

    chmod +x "$SCRIPT_PATH"
    print_success "Monitoring script created and made executable"
}

# Function to create LaunchAgent plist
create_launch_agent() {
    print_status "Creating LaunchAgent at $PLIST_PATH"
    
    mkdir -p "$(dirname "$PLIST_PATH")"
    
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SERVICE_NAME</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>KeepAlive</key>
    <true/>
    
    <key>StandardOutPath</key>
    <string>$LOG_DIR/auto-shutdown-idle-stdout.log</string>
    
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/auto-shutdown-idle-stderr.log</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    
    <key>ProcessType</key>
    <string>Background</string>
    
    <key>LowPriorityIO</key>
    <true/>
    
    <key>Nice</key>
    <integer>10</integer>
</dict>
</plist>
EOF

    print_success "LaunchAgent plist created"
}

# Function to setup sudo permissions
setup_sudo_permissions() {
    print_status "Setting up sudo permissions for shutdown command"
    
    local username=$(whoami)
    local sudoers_content="$username ALL=(ALL) NOPASSWD: /sbin/shutdown"
    
    if [[ -f "$SUDOERS_PATH" ]]; then
        print_warning "Sudoers file already exists, updating it"
        echo "$sudoers_content" | sudo tee "$SUDOERS_PATH" > /dev/null
    else
        echo "$sudoers_content" | sudo tee "$SUDOERS_PATH" > /dev/null
    fi
    
    # Test sudo permissions
    if sudo -n /sbin/shutdown -k now 2>/dev/null; then
        print_success "Sudo permissions configured successfully"
    else
        print_error "Failed to configure sudo permissions"
        exit 1
    fi
}

# Function to load and start the service
start_service() {
    print_status "Loading and starting the auto-shutdown service"
    
    # Unload if already loaded
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    
    # Load the service
    launchctl load "$PLIST_PATH"
    
    # Check if service is running
    sleep 2
    if launchctl list | grep -q "$SERVICE_NAME"; then
        print_success "Auto-shutdown service is now running"
        local pid=$(launchctl list | grep "$SERVICE_NAME" | awk '{print $1}')
        print_status "Service PID: $pid"
    else
        print_error "Failed to start the service"
        exit 1
    fi
}

# Function to stop and unload the service
stop_service() {
    print_status "Stopping auto-shutdown service"
    
    if launchctl list | grep -q "$SERVICE_NAME"; then
        launchctl unload "$PLIST_PATH"
        print_success "Service stopped"
    else
        print_warning "Service was not running"
    fi
}

# Function to install the auto-shutdown system
install_auto_shutdown() {
    print_status "Installing auto-shutdown system..."
    
    check_not_root
    
    # Create all components
    create_monitoring_script
    create_launch_agent
    setup_sudo_permissions
    start_service
    
    print_success "Auto-shutdown system installed successfully!"
    print_status "Your Mac will now shut down after 30 minutes of inactivity"
    print_status "Logs are available at: $LOG_DIR/auto-shutdown-idle.log"
    print_status ""
    print_status "Management commands:"
    print_status "  Status:    $0 status"
    print_status "  Uninstall: $0 uninstall"
}

# Function to uninstall the auto-shutdown system
uninstall_auto_shutdown() {
    print_status "Uninstalling auto-shutdown system..."
    
    # Stop service
    stop_service
    
    # Remove files
    [[ -f "$SCRIPT_PATH" ]] && rm -f "$SCRIPT_PATH" && print_status "Removed monitoring script"
    [[ -f "$PLIST_PATH" ]] && rm -f "$PLIST_PATH" && print_status "Removed LaunchAgent"
    [[ -d "$SCRIPT_DIR" ]] && rmdir "$SCRIPT_DIR" 2>/dev/null && print_status "Removed script directory"
    
    # Remove sudo permissions
    if [[ -f "$SUDOERS_PATH" ]]; then
        sudo rm -f "$SUDOERS_PATH"
        print_status "Removed sudo permissions"
    fi
    
    print_success "Auto-shutdown system uninstalled successfully!"
}

# Function to show status
show_status() {
    print_status "Auto-shutdown system status:"
    echo
    
    # Check if files exist
    if [[ -f "$SCRIPT_PATH" ]]; then
        print_success "✓ Monitoring script exists"
    else
        print_error "✗ Monitoring script missing"
    fi
    
    if [[ -f "$PLIST_PATH" ]]; then
        print_success "✓ LaunchAgent exists"
    else
        print_error "✗ LaunchAgent missing"
    fi
    
    if [[ -f "$SUDOERS_PATH" ]]; then
        print_success "✓ Sudo permissions configured"
    else
        print_error "✗ Sudo permissions missing"
    fi
    
    # Check if service is running
    if launchctl list | grep -q "$SERVICE_NAME"; then
        local pid=$(launchctl list | grep "$SERVICE_NAME" | awk '{print $1}')
        print_success "✓ Service is running (PID: $pid)"
    else
        print_error "✗ Service is not running"
    fi
    
    # Show recent log entries
    if [[ -f "$LOG_DIR/auto-shutdown-idle.log" ]]; then
        echo
        print_status "Recent log entries:"
        tail -5 "$LOG_DIR/auto-shutdown-idle.log" 2>/dev/null || print_warning "No log entries found"
    fi
    
    # Show current idle time
    echo
    local current_idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000}')
    if [[ -n "$current_idle" ]]; then
        print_status "Current system idle time: ${current_idle} seconds"
    fi
}

# Main script logic
main() {
    local action=${1:-install}
    
    case "$action" in
        install)
            install_auto_shutdown
            ;;
        uninstall)
            uninstall_auto_shutdown
            ;;
        status)
            show_status
            ;;
        *)
            echo "Usage: $0 [install|uninstall|status]"
            echo ""
            echo "  install   - Install and start auto-shutdown system (default)"
            echo "  uninstall - Remove auto-shutdown system"
            echo "  status    - Show current status"
            echo ""
            echo "This script sets up automatic shutdown after 30 minutes of inactivity."
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"