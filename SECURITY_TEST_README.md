# Security Test Files for SonarCloud SARIF Testing

This directory contains intentional security vulnerability test files to verify that SonarCloud properly detects security issues and generates SARIF reports for the GitHub Security tab.

## Test Files

### `test_security_issues.py`
Python file containing various security vulnerabilities:
- Hardcoded credentials (passwords, API keys, tokens)
- SQL injection vulnerabilities  
- Command injection risks
- Weak cryptographic hashing (MD5)
- Insecure random number generation
- Pickle deserialization vulnerabilities
- Path traversal issues
- Weak SSL/TLS configuration
- Information disclosure
- Insecure file operations
- LDAP injection
- XXE vulnerabilities

### `test_security_issues.js`
JavaScript file containing web application security issues:
- Hardcoded secrets and database URLs
- Code injection via eval()
- XSS vulnerabilities
- Insecure cookie settings
- Weak encryption/hashing
- Command injection
- Path traversal
- Insecure deserialization
- Information disclosure
- Certificate validation bypass
- Prototype pollution
- Timing attack vulnerabilities

### `test_security_issues.sh`
Shell script containing system-level security issues:
- Hardcoded credentials in scripts
- Command injection via eval
- Insecure file permissions (777)
- Path traversal vulnerabilities
- Insecure temporary file handling
- Weak random number generation
- Information disclosure in logs
- Insecure network operations (curl -k)
- Credential exposure in process lists
- Race conditions
- Shell injection risks
- Insecure SSH configurations

## Expected SonarCloud Detections

When SonarCloud analyzes these files, it should detect and report:

1. **Security Hotspots**: Hardcoded credentials, weak cryptography
2. **Vulnerabilities**: Injection attacks, insecure configurations
3. **Code Smells**: Poor security practices, information disclosure

## SARIF Report Testing

These files are specifically designed to test:
- ✅ SonarCloud security rule detection
- ✅ SARIF report generation with security findings
- ✅ GitHub Security tab population with alerts
- ✅ Proper severity mapping (error/warning/note)
- ✅ Accurate file locations and line numbers

## Important Note

⚠️ **DO NOT USE THIS CODE IN PRODUCTION!** ⚠️

These files contain intentional security vulnerabilities and should only be used for testing security analysis tools. They should be removed from production codebases.

## Cleanup

After testing is complete, these files can be safely deleted:
```bash
rm test_security_issues.py
rm test_security_issues.js  
rm test_security_issues.sh
rm SECURITY_TEST_README.md
```