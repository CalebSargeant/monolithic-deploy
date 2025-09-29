# 🚀 Ultimate Pre-commit Hook System

## The Magic One-Liner

Any repository can get **complete enterprise-grade validation** with just:

```yaml
repos:
  - repo: https://github.com/calebsargeant/infra
    rev: v1.0.0  # Use latest version
    hooks:
      - id: all
```

That's it! **One hook. Complete validation.**

## What the "all" Hook Provides

The single `all` hook intelligently provides:

### 🛡️ **Security Scanning**
- Secrets detection (detect-secrets, patterns)
- Vulnerability scanning (bandit, npm audit, trivy)
- Infrastructure security (tfsec, checkov, terrascan)
- Container security (hadolint, compose analysis)

### 🏗️ **Infrastructure Validation**
- Terraform formatting and validation
- Terraform security and compliance scanning
- Docker and container best practices
- Infrastructure documentation generation

### 🐍 **Python Quality**
- Code formatting (black, isort)
- Linting and complexity (flake8, radon)
- Security scanning (bandit)
- Type checking (mypy) when available

### 📋 **JavaScript/TypeScript Quality**
- Code formatting (prettier)
- Linting (eslint with security rules)
- Type checking and build validation
- Bundle size and performance monitoring

### ⚡ **Performance & Compliance**
- Performance regression detection
- License compliance validation
- Code metrics and quality trends
- File formatting and validation

## 🎯 Quick Setup

### New Repository
```bash
# 1. Copy the magic configuration
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/calebsargeant/infra
    rev: main
    hooks:
      - id: all
EOF

# 2. Install pre-commit (standard)
pip install pre-commit
pre-commit install

# 3. Done! Enterprise validation ready 🚀
```

### Existing Repository
```bash
# Replace your complex configuration with the one-liner
# Backup first: cp .pre-commit-config.yaml .pre-commit-config.yaml.backup
```

## 🧠 Intelligent Behavior

The hook adapts automatically based on:

### **File Types Detected**
- **Python files** → Python quality pipeline
- **JavaScript/TypeScript** → JS quality pipeline  
- **Terraform files** → Infrastructure validation
- **Docker files** → Container security
- **Any files** → Security scanning + file validation

### **Git Context**
- **pre-commit stage** → Fast feedback (formatting, basic security)
- **pre-push stage** → Comprehensive validation (full security, performance, compliance)

### **Tool Availability**
- **Tool present** → Full validation with that tool
- **Tool missing** → Graceful degradation with installation guidance

## 🔧 Configuration Options

### Environment Variables
```bash
# Control security strictness
FAIL_ON_HIGH_SEVERITY=true   # Default: true
FAIL_ON_MEDIUM_SEVERITY=false # Default: false

# Performance thresholds
PERFORMANCE_THRESHOLD=5.0     # seconds
MEMORY_THRESHOLD=100         # MB

# Skip temporarily
SKIP=all git commit -m "WIP: debugging"
```

### Project-Specific Extensions
```yaml
repos:
  - repo: https://github.com/calebsargeant/infra
    rev: v1.0.0
    hooks:
      - id: all

  # Add project-specific validation
  - repo: local
    hooks:
      - id: custom-business-rules
        name: Custom business validation
        entry: scripts/validate-business-rules.sh
        language: script
```

## 📊 Before vs After

| Repository Setup | Before (Complex) | After (Magic Hook) |
|------------------|------------------|-------------------|
| **Configuration** | 200+ lines YAML | 4 lines YAML |
| **Maintenance** | Per-repository | Centralized |
| **Setup Time** | 30+ minutes | 30 seconds |
| **Tool Management** | Manual | Automatic |
| **Updates** | Manual per repo | `pre-commit autoupdate` |
| **Consistency** | Varies | Identical |

## 🌟 Advanced Features

### Stage-Aware Execution
```bash
# Fast feedback on commit
git commit  # → formatting, linting, basic security

# Comprehensive validation on push  
git push    # → full security, performance, compliance
```

### Intelligent Tool Detection
```bash
# The hook automatically uses available tools and guides installation:
# "✅ Running bandit security scan..."
# "⚠️  tfsec not available - install with: brew install tfsec"
```

### Multi-Language Intelligence
```bash
# Automatically detects and validates:
# - Python projects → black, isort, flake8, bandit, mypy
# - JavaScript projects → prettier, eslint, security rules
# - Infrastructure → terraform, docker, kubernetes
# - Mixed projects → all applicable validations
```

## 🚀 Benefits

### ✅ **Ultimate Simplicity**
- **One hook** replaces complex configurations
- **Zero maintenance** per repository
- **Instant setup** for any new project

### ✅ **Enterprise Grade**
- **10+ security tools** orchestration
- **Multi-language** quality validation
- **Performance and compliance** monitoring

### ✅ **Future Proof**
- **Centralized updates** benefit all repositories
- **New tools** automatically available
- **Industry best practices** continuously integrated

## 🎯 Usage Examples

### For Teams
```bash
# New developer onboarding
git clone any-repo
pre-commit install
# That's it - enterprise validation ready!
```

### For CI/CD
```yaml
# GitHub Actions
- name: Validate Code
  run: |
    pip install pre-commit
    pre-commit run --all-files
```

### For Migration
```bash
# From complex pre-commit configs
cp .pre-commit-config.yaml .pre-commit-config.yaml.backup
echo 'repos:
  - repo: https://github.com/calebsargeant/infra
    rev: main
    hooks:
      - id: all' > .pre-commit-config.yaml
```

---

## 🏆 The Result

**One hook. Complete validation. Zero maintenance.**

Perfect for teams who want enterprise-grade quality without the enterprise-grade complexity.

*Maintained centrally. Updated automatically. Works everywhere.*