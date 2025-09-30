/**
 * Test file with intentional security vulnerabilities for SonarCloud SARIF testing.
 * This file contains various JavaScript security issues that SonarCloud should detect.
 */

// Security Issue 1: Hardcoded credentials
const API_KEY = "sk-1234567890abcdef"; // SonarCloud should flag this
const DATABASE_URL = "mongodb://admin:password123@localhost:27017/mydb";
const JWT_SECRET = "my_super_secret_key";

// Security Issue 2: eval() usage - code injection vulnerability
function executeUserCode(userInput) {
    return eval(userInput); // Dangerous - arbitrary code execution
}

// Security Issue 3: Insecure random number generation
function generateSessionId() {
    return Math.random().toString(36); // Not cryptographically secure
}

// Security Issue 4: SQL injection vulnerability
function getUserById(id) {
    const query = `SELECT * FROM users WHERE id = ${id}`; // SQL injection risk
    return query;
}

// Security Issue 5: XSS vulnerability - innerHTML with user data
function displayUserData(userData) {
    document.getElementById("user-info").innerHTML = userData; // XSS risk
}

// Security Issue 6: Insecure cookie settings
function setAuthCookie(token) {
    document.cookie = `auth_token=${token}; path=/`; // Missing secure, httpOnly, sameSite
}

// Security Issue 7: Weak encryption/hashing
const crypto = require('crypto');
function hashPassword(password) {
    return crypto.createHash('md5').update(password).digest('hex'); // MD5 is weak
}

// Security Issue 8: Path traversal vulnerability
const fs = require('fs');
function readUserFile(filename) {
    return fs.readFileSync(`/var/uploads/${filename}`, 'utf8'); // No path validation
}

// Security Issue 9: Command injection
const { exec } = require('child_process');
function processFile(filename) {
    exec(`convert ${filename} output.jpg`); // Command injection risk
}

// Security Issue 10: Insecure deserialization
function loadUserSession(sessionData) {
    return JSON.parse(sessionData); // Should validate/sanitize first
}

// Security Issue 11: Information disclosure in error messages
function authenticateUser(username, password) {
    if (!userExists(username)) {
        throw new Error(`User ${username} does not exist`); // Username disclosure
    }
    if (!isValidPassword(username, password)) {
        throw new Error(`Invalid password for user ${username}`); // Username disclosure
    }
}

// Security Issue 12: Insecure HTTP requests
const https = require('https');
function makeApiCall(url) {
    const options = {
        rejectUnauthorized: false // Disables certificate validation
    };
    return https.get(url, options);
}

// Security Issue 13: Prototype pollution vulnerability
function mergeObjects(target, source) {
    for (let key in source) {
        target[key] = source[key]; // No protection against __proto__ pollution
    }
    return target;
}

// Security Issue 14: Missing input validation
function transferFunds(fromAccount, toAccount, amount) {
    // No validation on amount, could be negative
    return processTransfer(fromAccount, toAccount, amount);
}

// Security Issue 15: Timing attack vulnerability
function comparePasswords(input, stored) {
    if (input.length !== stored.length) {
        return false; // Early return reveals length information
    }
    for (let i = 0; i < input.length; i++) {
        if (input[i] !== stored[i]) {
            return false; // Early return enables timing attacks
        }
    }
    return true;
}

// Security Issue 16: Debug information exposure
const DEBUG = true;
if (DEBUG) {
    console.log(`Database URL: ${DATABASE_URL}`); // Credential exposure
    console.log(`JWT Secret: ${JWT_SECRET}`);
}

// Dummy functions to make the code syntactically correct
function userExists(username) { return true; }
function isValidPassword(username, password) { return false; }
function processTransfer(from, to, amount) { return "processed"; }

console.log("This file contains intentional security vulnerabilities for testing");
console.log("Do not use this code in production!");