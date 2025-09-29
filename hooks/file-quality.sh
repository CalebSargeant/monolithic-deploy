#!/bin/bash

# File Quality Validation
# General file formatting, syntax, and quality checks

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

ISSUES_FOUND=0

echo -e "${BLUE}File Quality Validation${NC}"

# Get files to check
if git diff --cached --name-only >/dev/null 2>&1; then
    FILES=$(git diff --cached --name-only)
else
    FILES=$(git ls-files | head -50)
fi

# Check for trailing whitespace
if echo "$FILES" | xargs grep -l "[[:space:]]$" 2>/dev/null | head -5; then
    echo -e "${YELLOW}⚠ Files with trailing whitespace found${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for large files
LARGE_FILES=$(echo "$FILES" | xargs ls -la 2>/dev/null | awk '$5 > 1048576 {print $9}' || true)
if [ -n "$LARGE_FILES" ]; then
    echo -e "${YELLOW}⚠ Large files detected (>1MB):${NC}"
    echo "$LARGE_FILES" | head -3
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check YAML files
YAML_FILES=$(echo "$FILES" | grep -E "\.(yaml|yml)$" || true)
if [ -n "$YAML_FILES" ] && command -v yamllint >/dev/null 2>&1; then
    if ! echo "$YAML_FILES" | xargs yamllint -c '{extends: relaxed, rules: {line-length: {max: 120}}}' >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠ YAML formatting issues found${NC}"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
fi

# Check JSON files
JSON_FILES=$(echo "$FILES" | grep "\.json$" || true)
if [ -n "$JSON_FILES" ]; then
    for json_file in $JSON_FILES; do
        if [ -f "$json_file" ] && ! python3 -m json.tool "$json_file" >/dev/null 2>&1; then
            echo -e "${RED}❌ Invalid JSON: $json_file${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    done
fi

# Summary
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ File quality checks passed${NC}"
    exit 0
else
    echo -e "${YELLOW}Found $ISSUES_FOUND file quality issues${NC}"
    exit 1
fi