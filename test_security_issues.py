#!/usr/bin/env python3
"""
Test file with intentional security vulnerabilities for SonarCloud SARIF testing.
This file contains various security issues that SonarCloud should detect.
"""

import os
import subprocess
import hashlib
import random
import pickle

# Security Issue 1: Hardcoded credentials
DATABASE_PASSWORD = "admin123"  # SonarCloud should flag this
API_KEY = "sk-1234567890abcdef"
SECRET_TOKEN = "supersecret"

# Security Issue 2: SQL Injection vulnerability
def get_user_data(user_id):
    query = f"SELECT * FROM users WHERE id = {user_id}"  # SQL injection risk
    # This would be vulnerable in a real database query
    return query

# Security Issue 3: Command injection vulnerability  
def run_command(user_input):
    # Direct command execution with user input
    result = subprocess.run(f"ls {user_input}", shell=True)  # Command injection
    return result

# Security Issue 4: Weak cryptographic hash
def hash_password(password):
    return hashlib.md5(password.encode()).hexdigest()  # MD5 is weak

# Security Issue 5: Insecure random number generation
def generate_token():
    return str(random.random())  # Not cryptographically secure

# Security Issue 6: Pickle deserialization vulnerability
def load_user_data(data):
    return pickle.loads(data)  # Unsafe deserialization

# Security Issue 7: Path traversal vulnerability
def read_file(filename):
    with open(f"/var/data/{filename}", 'r') as f:  # No path validation
        return f.read()

# Security Issue 8: Weak SSL/TLS configuration
import ssl
def create_context():
    context = ssl.create_default_context()
    context.check_hostname = False  # Disables hostname verification
    context.verify_mode = ssl.CERT_NONE  # Disables certificate verification
    return context

# Security Issue 9: Debug information disclosure
DEBUG = True
if DEBUG:
    print(f"Database password: {DATABASE_PASSWORD}")  # Information disclosure

# Security Issue 10: Insecure temporary file creation
import tempfile
def create_temp_file():
    # Creates file with predictable name and insecure permissions
    temp_path = "/tmp/myapp_" + str(random.randint(1000, 9999))
    with open(temp_path, 'w') as f:
        f.write("sensitive data")
    os.chmod(temp_path, 0o777)  # World writable
    return temp_path

# Security Issue 11: LDAP injection
def authenticate_user(username):
    ldap_query = f"(&(uid={username})(objectClass=person))"  # LDAP injection
    return ldap_query

# Security Issue 12: XXE vulnerability simulation
def parse_xml(xml_data):
    import xml.etree.ElementTree as ET
    # Parsing XML without disabling external entities
    root = ET.fromstring(xml_data)  # Vulnerable to XXE
    return root

if __name__ == "__main__":
    print("This file contains intentional security vulnerabilities for testing")
    print("Do not use this code in production!")