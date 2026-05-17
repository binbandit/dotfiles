#!/bin/bash
# Template: Form Automation Workflow
# Purpose: Fill and submit web forms with validation
# Usage: ./form-automation.sh <form-url>
#
# This template demonstrates the snapshot-interact-verify pattern:
# 1. Navigate to form
# 2. Snapshot to get element refs
# 3. Fill fields using refs
# 4. Submit and verify result
#
# Customize: Update the refs (@e1, @e2, etc.) based on your form's snapshot output

set -euo pipefail

FORM_URL="${1:?Usage: $0 <form-url>}"

echo "Form automation: $FORM_URL"

# Step 1: Navigate to form
agent-browser --native open "$FORM_URL"
agent-browser --native wait --load networkidle

# Step 2: Snapshot to discover form elements
echo ""
echo "Form structure:"
agent-browser --native snapshot -i

# Step 3: Fill form fields (customize these refs based on snapshot output)
#
# Common field types:
#   agent-browser --native fill @e1 "John Doe"           # Text input
#   agent-browser --native fill @e2 "user@example.com"   # Email input
#   agent-browser --native fill @e3 "SecureP@ss123"      # Password input
#   agent-browser --native select @e4 "Option Value"     # Dropdown
#   agent-browser --native check @e5                     # Checkbox
#   agent-browser --native click @e6                     # Radio button
#   agent-browser --native fill @e7 "Multi-line text"   # Textarea
#   agent-browser --native upload @e8 /path/to/file.pdf # File upload
#
# Uncomment and modify:
# agent-browser --native fill @e1 "Test User"
# agent-browser --native fill @e2 "test@example.com"
# agent-browser --native click @e3  # Submit button

# Step 4: Wait for submission
# agent-browser --native wait --load networkidle
# agent-browser --native wait --url "**/success"  # Or wait for redirect

# Step 5: Verify result
echo ""
echo "Result:"
agent-browser --native get url
agent-browser --native snapshot -i

# Optional: Capture evidence
agent-browser --native screenshot /tmp/form-result.png
echo "Screenshot saved: /tmp/form-result.png"

# Cleanup
agent-browser --native close
echo "Done"
