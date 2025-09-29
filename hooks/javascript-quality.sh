#!/bin/bash

# JavaScript Quality Gate Hook
# Comprehensive JavaScript/TypeScript code quality validation

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BOLD}${BLUE}📋 JavaScript Quality Gate${NC}"
echo -e "${BOLD}${BLUE}═══════════════════════════════════════════════════════════════${NC}"

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

ISSUES_FOUND=0

# Get JS/TS files
if git diff --cached --name-only >/dev/null 2>&1; then
    JS_FILES=$(git diff --cached --name-only | grep -E "\.(js|ts|jsx|tsx)$" || true)
    CONTEXT="staged"
else
    JS_FILES=$(find . -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" | grep -v "node_modules" | grep -v ".git" | head -20)
    CONTEXT="repository"
fi

if [ -z "$JS_FILES" ]; then
    echo -e "${BLUE}No JavaScript/TypeScript files found - skipping JS quality checks${NC}"
    exit 0
fi

echo -e "${BLUE}Context: Validating ${CONTEXT} JavaScript/TypeScript files${NC}"
echo ""

# Check if we're in a Node.js project
if [ -f "package.json" ] || [ -f "frontend/package.json" ]; then
    if [ -f "frontend/package.json" ]; then
        cd frontend
    fi
    
    # 1. Prettier formatting
    if command -v prettier &> /dev/null || npm list prettier >/dev/null 2>&1; then
        echo -e "${BOLD}Running Prettier (formatter)...${NC}"
        if prettier --check $JS_FILES 2>/dev/null; then
            echo -e "${GREEN}✓ Prettier formatting passed${NC}"
        else
            echo -e "${YELLOW}⚠ Prettier found formatting issues (auto-fixable)${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
        echo ""
    fi
    
    # 2. ESLint linting
    if command -v eslint &> /dev/null || npm list eslint >/dev/null 2>&1; then
        echo -e "${BOLD}Running ESLint (linter)...${NC}"
        if eslint $JS_FILES 2>/dev/null; then
            echo -e "${GREEN}✓ ESLint linting passed${NC}"
        else
            echo -e "${RED}❌ ESLint found linting issues${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
        echo ""
    fi
    
    # 3. TypeScript checking (if TS files present)
    if echo "$JS_FILES" | grep -q "\.tsx\?$" && command -v tsc &> /dev/null; then
        echo -e "${BOLD}Running TypeScript compiler...${NC}"
        if tsc --noEmit 2>/dev/null; then
            echo -e "${GREEN}✓ TypeScript compilation passed${NC}"
        else
            echo -e "${YELLOW}⚠ TypeScript found type issues${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
        echo ""
    fi
    
    cd "$REPO_ROOT"
else
    echo -e "${YELLOW}⚠️  No package.json found - limited JavaScript validation available${NC}"
    echo ""
fi

# Basic syntax checks for any JS files
echo -e "${BOLD}Running basic syntax checks...${NC}"
SYNTAX_ISSUES=0

for js_file in $JS_FILES; do
    if [ -f "$js_file" ]; then
        # Basic Node.js syntax check
        if command -v node &> /dev/null; then
            if node -c "$js_file" 2>/dev/null; then
                echo -e "  ${GREEN}✓ $js_file syntax OK${NC}"
            else
                echo -e "  ${RED}❌ $js_file has syntax errors${NC}"
                SYNTAX_ISSUES=$((SYNTAX_ISSUES + 1))
            fi
        fi
    fi
done

if [ $SYNTAX_ISSUES -gt 0 ]; then
    ISSUES_FOUND=$((ISSUES_FOUND + SYNTAX_ISSUES))
fi

echo ""

# Summary
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ JavaScript quality gate passed!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Found $ISSUES_FOUND JavaScript quality issue(s)${NC}"
    echo -e "${BLUE}Consider running 'npm run format' or 'prettier --write .' to auto-fix${NC}"
    exit 1
fi