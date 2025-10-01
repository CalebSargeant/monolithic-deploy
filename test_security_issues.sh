#!/bin/bash

# Test script with intentional security vulnerabilities for SonarCloud SARIF testing.
# This file contains various shell script security issues that SonarCloud should detect.

# Security Issue 1: Hardcoded credentials
DB_PASSWORD="admin123"
API_TOKEN="sk-1234567890abcdef"
SSH_PRIVATE_KEY="/home/user/.ssh/id_rsa_hardcoded"

# Security Issue 2: Command injection vulnerability
process_user_input() {
    local user_input="$1"
    # Direct execution of user input without validation
    eval "$user_input"  # Dangerous command injection
}

# Security Issue 3: Insecure file permissions
create_config_file() {
    echo "password=$DB_PASSWORD" > /tmp/config.txt
    chmod 777 /tmp/config.txt  # World readable/writable
}

# Security Issue 4: Path traversal vulnerability
read_user_file() {
    local filename="$1"
    # No path validation - allows ../../../etc/passwd
    cat "/var/data/$filename"
}

# Security Issue 5: Insecure temporary file usage
create_temp_script() {
    local temp_file="/tmp/script_$$"
    echo "#!/bin/bash" > $temp_file
    echo "echo 'Running with credentials: $DB_PASSWORD'" >> $temp_file
    chmod +x $temp_file
    # Temp file with predictable name and exposed credentials
    $temp_file
}

# Security Issue 6: Weak random number generation
generate_session_id() {
    # Using RANDOM which is not cryptographically secure
    echo "session_$RANDOM$RANDOM"
}

# Security Issue 7: Information disclosure in logs
debug_mode=true
if [ "$debug_mode" = true ]; then
    echo "Database password: $DB_PASSWORD" >> /var/log/app.log
    echo "API token: $API_TOKEN" >> /var/log/app.log
fi

# Security Issue 8: Insecure network operations
download_file() {
    local url="$1"
    local output="$2"
    # No certificate validation
    curl -k -o "$output" "$url"  # -k disables certificate verification
}

# Security Issue 9: Command substitution without validation
backup_database() {
    local db_name="$1"
    # Command substitution with user input
    backup_file="backup_$(date +%Y%m%d)_$db_name.sql"
    mysqldump -u admin -p$DB_PASSWORD $db_name > $backup_file
}

# Security Issue 10: Exposed credentials in process list
start_service() {
    # Password visible in process list
    mysql -u admin -p$DB_PASSWORD -e "SELECT 1"
}

# Security Issue 11: Insecure file operations
process_archive() {
    local archive="$1"
    # Extracting without path validation - zip slip vulnerability
    unzip "$archive" -d /tmp/extract/
}

# Security Issue 12: Race condition with temp files
create_lock_file() {
    local lock_file="/tmp/app.lock"
    if [ ! -f "$lock_file" ]; then
        # Race condition between check and creation
        echo $$ > "$lock_file"
    fi
}

# Security Issue 13: Shell injection via interpolation
search_logs() {
    local search_term="$1"
    # Shell injection risk
    grep "$search_term" /var/log/app.log | head -10
}

# Security Issue 14: Insecure defaults
setup_ssh() {
    # Weak SSH configuration
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
}

# Security Issue 15: Credential exposure via environment
export DATABASE_PASSWORD="$DB_PASSWORD"  # Exposed to child processes
export API_SECRET="$API_TOKEN"

# Security Issue 16: Insecure URL handling
fetch_data() {
    local api_url="$1"
    # No URL validation - could be file:// or other protocols
    wget -O - "$api_url"
}

echo "This script contains intentional security vulnerabilities for testing"
echo "Do not use this code in production!"

# Call some functions to make them "used"
generate_session_id > /dev/null
create_config_file