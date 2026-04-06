#!/usr/bin/env bash
set -euo pipefail

# Get the file path from hook input (passed via stdin as JSON)
FILE_PATH=$(jq -r '.tool_input.file_path')

# Format with Prettier
npx prettier --write "$FILE_PATH"

# Fix with ESLint (converts quotes to backticks, etc.)
npx eslint --fix "$FILE_PATH"