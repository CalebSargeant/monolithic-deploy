#!/bin/bash

# AWS SSO Auto Login - All-in-One Script
# Author: Caleb Sargeant
# Description: Automatically configures and manages AWS SSO login with browser cleanup
# Usage: ./aws-sso-auto-login.sh [setup|login|status|startup|install|uninstall|logs|cleanup|help]

set -euo pipefail

# Configuration
CONFIG_FILE="$HOME/.aws-sso-auto-login.conf"
LOG_FILE="$HOME/.aws-sso-auto-login.log"
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SERVICE_NAME="com.sargeant.aws-sso-auto-login"
PLIST_PATH="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Default browser
DEFAULT_BROWSER="Brave Browser"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Function to load configuration
load_config() {
    # Default profiles (can be overridden)
    PROFILES=(
        "p1-dev"
        "p1-staging" 
        "p1-prod"
        "p1-shared"
        "p1-network"
    )
    BROWSER="$DEFAULT_BROWSER"
    
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
}

# Function to create initial configuration
create_config() {
    print_status "$BLUE" "🔧 Setting up AWS SSO Auto Login configuration..."
    
    # Ask for AWS profiles
    echo ""
    print_status "$YELLOW" "📝 AWS Profile Configuration"
    echo "Enter your AWS profiles (press Enter after each, empty line to finish):"
    
    local user_profiles=()
    local profile
    while true; do
        read -p "Profile name (or press Enter to finish): " profile
        if [ -z "$profile" ]; then
            break
        fi
        user_profiles+=("$profile")
        print_status "$GREEN" "   Added: $profile"
    done
    
    # Ask for browser preference
    echo ""
    print_status "$YELLOW" "🌐 Browser Configuration"
    echo "Available browsers:"
    echo "  1. Brave Browser (default)"
    echo "  2. Google Chrome"
    echo "  3. Safari"
    echo "  4. Firefox"
    
    local browser_choice
    read -p "Choose browser (1-4) [1]: " browser_choice
    browser_choice=${browser_choice:-1}
    
    case "$browser_choice" in
        1) BROWSER="Brave Browser" ;;
        2) BROWSER="Google Chrome" ;;
        3) BROWSER="Safari" ;;
        4) BROWSER="Firefox" ;;
        *) BROWSER="Brave Browser" ;;
    esac
    
    # Save configuration
    cat > "$CONFIG_FILE" << EOF
# AWS SSO Auto Login Configuration
# Generated on $(date)

# AWS Profiles
PROFILES=(
EOF
    
    if [ ${#user_profiles[@]} -gt 0 ]; then
        for profile in "${user_profiles[@]}"; do
            echo "    \"$profile\"" >> "$CONFIG_FILE"
        done
    else
        # Use defaults if no profiles specified
        for profile in "${PROFILES[@]}"; do
            echo "    \"$profile\"" >> "$CONFIG_FILE"
        done
    fi
    
    cat >> "$CONFIG_FILE" << EOF
)

# Browser preference
BROWSER="$BROWSER"
EOF
    
    print_status "$GREEN" "✅ Configuration saved to: $CONFIG_FILE"
    print_status "$BLUE" "📋 Browser: $BROWSER"
    
    # Load the new configuration
    load_config
}

# Function to check if profile is already logged in
is_logged_in() {
    local profile=$1
    # Use perl for timeout since macOS doesn't have GNU timeout by default
    perl -e 'alarm(5); exec @ARGV' aws sts get-caller-identity --profile "$profile" &>/dev/null
}

# Function to detect default browser
detect_browser() {
    if [ -n "${BROWSER:-}" ]; then
        echo "$BROWSER"
        return
    fi
    
    # Try to detect running browsers
    if pgrep -f "Brave Browser" >/dev/null 2>&1; then
        echo "Brave Browser"
    elif pgrep -f "Google Chrome" >/dev/null 2>&1; then
        echo "Google Chrome"
    elif pgrep -f "Firefox" >/dev/null 2>&1; then
        echo "Firefox"
    else
        echo "$DEFAULT_BROWSER"
    fi
}

# Function to close browser tabs/windows related to AWS SSO
close_aws_sso_tabs() {
    local browser="$1"
    
    print_status "$BLUE" "🧹 Cleaning up AWS SSO browser tabs..."
    
    case "$browser" in
        "Google Chrome"|"chrome")
            close_chrome_sso_tabs
            ;;
        "Brave Browser"|"brave")
            close_brave_sso_tabs
            ;;
        "Firefox"|"firefox")
            close_firefox_sso_tabs
            ;;
        "Safari"|"safari")
            close_safari_sso_tabs
            ;;
        *)
            print_status "$YELLOW" "⚠️  Unknown browser: $browser. Manual cleanup may be needed."
            ;;
    esac
}

# Function to close Chrome SSO tabs
close_chrome_sso_tabs() {
    if ! command -v osascript >/dev/null 2>&1; then
        return
    fi
    
    osascript <<'EOF' 2>/dev/null || true
tell application "Google Chrome"
    if it is running then
        repeat with w in windows
            set tabsToClose to {}
            repeat with t in tabs of w
                if URL of t contains "amazonaws.com" or URL of t contains "127.0.0.1" or URL of t contains "oauth/callback" then
                    set end of tabsToClose to t
                end if
            end repeat
            repeat with t in reverse of tabsToClose
                close t
            end repeat
        end repeat
    end if
end tell
EOF
    
    if [ $? -eq 0 ]; then
        print_status "$GREEN" "✅ Closed Chrome AWS SSO tabs"
    fi
}

# Function to close Brave Browser SSO tabs
close_brave_sso_tabs() {
    if ! command -v osascript >/dev/null 2>&1; then
        return
    fi
    
    osascript <<'EOF' 2>/dev/null || true
tell application "Brave Browser"
    if it is running then
        repeat with w in windows
            set tabsToClose to {}
            repeat with t in tabs of w
                if URL of t contains "amazonaws.com" or URL of t contains "127.0.0.1" or URL of t contains "oauth/callback" then
                    set end of tabsToClose to t
                end if
            end repeat
            repeat with t in reverse of tabsToClose
                close t
            end repeat
        end repeat
    end if
end tell
EOF
    
    if [ $? -eq 0 ]; then
        print_status "$GREEN" "✅ Closed Brave Browser AWS SSO tabs"
    fi
}

# Function to close Firefox SSO tabs
close_firefox_sso_tabs() {
    print_status "$YELLOW" "⚠️  Firefox tab cleanup requires manual intervention"
    print_status "$BLUE" "💡 You can manually close tabs containing 'amazonaws.com' or '127.0.0.1'"
}

# Function to close Safari SSO tabs
close_safari_sso_tabs() {
    if ! command -v osascript >/dev/null 2>&1; then
        return
    fi
    
    osascript <<'EOF' 2>/dev/null || true
tell application "Safari"
    if it is running then
        repeat with w in windows
            set tabsToClose to {}
            repeat with t in tabs of w
                if URL of t contains "amazonaws.com" or URL of t contains "127.0.0.1" or URL of t contains "oauth/callback" then
                    set end of tabsToClose to t
                end if
            end repeat
            repeat with t in reverse of tabsToClose
                close t
            end repeat
        end repeat
    end if
end tell
EOF
    
    if [ $? -eq 0 ]; then
        print_status "$GREEN" "✅ Closed Safari AWS SSO tabs"
    fi
}

# Function to show login status for all profiles
show_status() {
    load_config
    
    print_status "$YELLOW" "\n📊 Current login status:"
    echo "================================"
    
    if [ ${#PROFILES[@]} -eq 0 ]; then
        print_status "$RED" "❌ No AWS profiles configured. Run: $0 setup"
        return
    fi
    
    for profile in "${PROFILES[@]}"; do
        if is_logged_in "$profile"; then
            print_status "$GREEN" "✅ $profile: Logged in"
        else
            print_status "$RED" "❌ $profile: Not logged in"
        fi
    done
    echo ""
}

# Function to perform AWS SSO login with cleanup
perform_login() {
    load_config
    
    print_status "$BLUE" "🚀 AWS SSO Login with Browser Cleanup"
    
    if [ ${#PROFILES[@]} -eq 0 ]; then
        print_status "$RED" "❌ No AWS profiles configured. Run: $0 setup"
        return 1
    fi
    
    # Detect browser
    local browser
    browser=$(detect_browser)
    print_status "$BLUE" "🔍 Using browser: $browser"
    
    log_message "Starting AWS SSO login process with browser: $browser"
    
    # Show initial status
    show_status
    
    # Check which profiles need login
    local needs_login=()
    for profile in "${PROFILES[@]}"; do
        if ! is_logged_in "$profile"; then
            needs_login+=("$profile")
        fi
    done
    
    if [ ${#needs_login[@]} -eq 0 ]; then
        print_status "$GREEN" "🎉 All profiles are already logged in!"
        log_message "All profiles already logged in"
        return 0
    fi
    
    print_status "$YELLOW" "📝 Profiles needing login: ${needs_login[*]}"
    log_message "Profiles needing login: ${needs_login[*]}"
    echo ""
    
    # Login to each profile that needs it
    local failed_logins=()
    
    for profile in "${needs_login[@]}"; do
        print_status "$BLUE" "🔐 Logging into profile: $profile"
        print_status "$MAGENTA" "🌐 Opening browser for authentication..."
        log_message "Attempting login for profile: $profile"
        
        # Perform the login (this will open browser tabs)
        if aws sso login --profile "$profile"; then
            print_status "$GREEN" "✅ Successfully logged into $profile"
            log_message "Successfully logged into $profile"
            
            # Give a moment for the authentication to complete
            sleep 2
            
            # Clean up browser tabs
            close_aws_sso_tabs "$browser"
        else
            print_status "$RED" "❌ Failed to login to $profile"
            log_message "Failed to login to $profile"
            failed_logins+=("$profile")
        fi
        
        echo ""
        
        # Brief pause between logins to avoid overwhelming
        if [ "${#needs_login[@]}" -gt 1 ]; then
            sleep 1
        fi
    done
    
    # Final cleanup - catch any remaining tabs
    if [ ${#needs_login[@]} -gt 0 ]; then
        print_status "$BLUE" "🧹 Final cleanup of any remaining AWS SSO tabs..."
        close_aws_sso_tabs "$browser"
    fi
    
    # Final status report
    print_status "$YELLOW" "🏁 Login process completed!"
    show_status
    
    # Report any failures
    if [ ${#failed_logins[@]} -gt 0 ]; then
        print_status "$RED" "⚠️  Failed to login to: ${failed_logins[*]}"
        log_message "Failed logins: ${failed_logins[*]}"
        return 1
    else
        print_status "$GREEN" "🎉 All profiles are now logged in!"
        print_status "$GREEN" "🧹 Browser cleanup completed!"
        log_message "All profiles successfully logged in"
        return 0
    fi
}

# Function for startup mode (used by login items)
startup_mode() {
    log_message "AWS SSO Login Startup Script Started"
    
    # Wait for system to settle
    log_message "Waiting 10 seconds for system to settle..."
    sleep 10
    
    # Check network connectivity
    log_message "Checking network connectivity..."
    for i in {1..30}; do
        if ping -c 1 google.com >/dev/null 2>&1; then
            log_message "Network is available"
            break
        fi
        log_message "Waiting for network... (attempt $i/30)"
        sleep 2
    done
    
    # Check if AWS CLI is available
    if ! command -v aws >/dev/null 2>&1; then
        log_message "ERROR: AWS CLI not found in PATH"
        return 1
    fi
    
    log_message "Starting AWS SSO login process..."
    
    # Run the login process
    if perform_login >> "$LOG_FILE" 2>&1; then
        log_message "AWS SSO login completed successfully"
    else
        log_message "AWS SSO login failed with exit code $?"
    fi
    
    log_message "AWS SSO Login Startup Script Completed"
}

# Function to check if LaunchAgent exists and is running
check_service() {
    launchctl list | grep -q "$SERVICE_NAME"
}

# Function to create LaunchAgent plist
create_launch_agent() {
    print_status "$BLUE" "🔧 Creating LaunchAgent at $PLIST_PATH"
    
    mkdir -p "$(dirname "$PLIST_PATH")"
    
    # Create a wrapper script that runs in startup mode
    local wrapper_script="$HOME/Library/Scripts/aws-sso-startup-wrapper.sh"
    mkdir -p "$(dirname "$wrapper_script")"
    
    cat > "$wrapper_script" << EOF
#!/bin/bash
exec "$SCRIPT_PATH" startup
EOF
    
    chmod +x "$wrapper_script"
    
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SERVICE_NAME</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>$wrapper_script</string>
    </array>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>StandardOutPath</key>
    <string>$LOG_FILE</string>
    
    <key>StandardErrorPath</key>
    <string>$LOG_FILE</string>
    
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
    
    <key>ProcessType</key>
    <string>Background</string>
</dict>
</plist>
EOF
    
    print_status "$GREEN" "✅ LaunchAgent plist created"
}

# Function to install LaunchAgent
install_launch_agent() {
    print_status "$BLUE" "🔧 Installing AWS SSO Auto Login at startup..."
    
    # Stop existing service if running
    if check_service; then
        print_status "$YELLOW" "⚠️  Existing service found, stopping..."
        stop_service
    fi
    
    # Create LaunchAgent
    create_launch_agent
    
    # Load and start service
    start_service
    
    if check_service; then
        print_status "$GREEN" "✅ AWS SSO Auto Login startup installed successfully"
        print_status "$BLUE" "📝 The script will run automatically when you login to macOS"
        print_status "$BLUE" "📋 Logs will be written to: $LOG_FILE"
    else
        print_status "$RED" "❌ Failed to install LaunchAgent"
        return 1
    fi
}

# Function to start the service
start_service() {
    print_status "$BLUE" "🚀 Starting AWS SSO Auto Login service..."
    
    # Unload if already loaded
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    
    # Load the service
    launchctl load "$PLIST_PATH"
    
    # Check if service is running
    sleep 1
    if check_service; then
        print_status "$GREEN" "✅ Service is now running"
    else
        print_status "$YELLOW" "⚠️  Service may take a moment to start"
    fi
}

# Function to stop the service
stop_service() {
    print_status "$BLUE" "🛑 Stopping AWS SSO Auto Login service..."
    
    if check_service; then
        launchctl unload "$PLIST_PATH"
        print_status "$GREEN" "✅ Service stopped"
    else
        print_status "$YELLOW" "⚠️  Service was not running"
    fi
}

# Function to uninstall LaunchAgent
uninstall_launch_agent() {
    print_status "$BLUE" "🗑️  Uninstalling AWS SSO Auto Login from startup..."
    
    # Stop service
    stop_service
    
    # Remove files
    if [[ -f "$PLIST_PATH" ]]; then
        rm -f "$PLIST_PATH"
        print_status "$GREEN" "✅ LaunchAgent removed"
    fi
    
    # Remove wrapper script
    local wrapper_script="$HOME/Library/Scripts/aws-sso-startup-wrapper.sh"
    if [[ -f "$wrapper_script" ]]; then
        rm -f "$wrapper_script"
        print_status "$GREEN" "✅ Wrapper script removed"
    fi
    
    if ! check_service; then
        print_status "$GREEN" "✅ AWS SSO Auto Login startup removed successfully"
    else
        print_status "$RED" "❌ Failed to remove service"
        return 1
    fi
}

# Function to show installation status
show_install_status() {
    print_status "$BLUE" "📊 AWS SSO Auto Login Status"
    echo "================================"
    
    # Check if LaunchAgent plist exists
    if [[ -f "$PLIST_PATH" ]]; then
        print_status "$GREEN" "✅ LaunchAgent is installed"
    else
        print_status "$RED" "❌ LaunchAgent is NOT installed"
    fi
    
    # Check if service is running
    if check_service; then
        print_status "$GREEN" "✅ Service is running"
    else
        print_status "$RED" "❌ Service is NOT running"
    fi
    
    echo ""
    print_status "$BLUE" "📁 Configuration:"
    if [ -f "$CONFIG_FILE" ]; then
        print_status "$GREEN" "   Config: $CONFIG_FILE"
        load_config
        print_status "$BLUE" "   Browser: $BROWSER"
        print_status "$BLUE" "   Profiles: ${PROFILES[*]}"
    else
        print_status "$YELLOW" "   No config found. Run: $0 setup"
    fi
    
    echo ""
    print_status "$BLUE" "📋 Script: $SCRIPT_PATH"
    print_status "$BLUE" "📋 Logs: $LOG_FILE"
}

# Function to show logs
show_logs() {
    if [ -f "$LOG_FILE" ]; then
        print_status "$BLUE" "📋 Last 20 lines of log:"
        echo "================================"
        tail -n 20 "$LOG_FILE"
    else
        print_status "$YELLOW" "⚠️  No log file found at: $LOG_FILE"
    fi
}

# Function to show help
show_help() {
    echo "AWS SSO Auto Login - All-in-One Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup       Initial setup and configuration"
    echo "  login       Perform AWS SSO login with browser cleanup"
    echo "  status      Show current AWS SSO login status"
    echo "  install     Install auto-login at macOS startup"
    echo "  uninstall   Remove auto-login from macOS startup"
    echo "  startup     Run in startup mode (used internally)"
    echo "  info        Show installation and configuration status"
    echo "  logs        Show recent log entries"
    echo "  cleanup     Clean up AWS SSO browser tabs only"
    echo "  help        Show this help message"
    echo ""
    echo "First time setup:"
    echo "  1. Run: $0 setup"
    echo "  2. Run: $0 install  (optional - for auto-login at startup)"
    echo "  3. Run: $0 login    (to test)"
    echo ""
    echo "Features:"
    echo "  • Configures AWS profiles automatically"
    echo "  • Opens browser tabs for authentication and closes them"
    echo "  • Supports Chrome, Brave, Safari, and Firefox browsers"
    echo "  • Can run automatically at macOS login"
    echo "  • Comprehensive logging and status reporting"
}

# Main script logic
main() {
    case "${1:-help}" in
        setup)
            create_config
            ;;
        login)
            perform_login
            ;;
        status)
            show_status
            ;;
        install)
            load_config
            install_launch_agent
            ;;
        uninstall)
            uninstall_launch_agent
            ;;
        startup)
            startup_mode
            ;;
        info)
            show_install_status
            ;;
        logs)
            show_logs
            ;;
        cleanup)
            load_config
            browser=$(detect_browser)
            close_aws_sso_tabs "$browser"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            show_help
            ;;
    esac
}

# If script is run with "startup" internally (from login items), handle differently
if [[ "${1:-}" == "startup" ]] || [[ "${0}" == *"LoginItems"* ]]; then
    startup_mode
else
    main "$@"
fi