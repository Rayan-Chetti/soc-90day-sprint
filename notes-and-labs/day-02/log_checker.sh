#!/bin/bash
set -euo pipefail

# 1. Enforce argument requirement
if [ $# -eq 0 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOG_FILE="$1"

# 2. Verify target evidence file exists on disk
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found."
    exit 1
fi

# 3. Extract log telemetry using command substitution
TOTAL_LINES=$(wc -l < "$LOG_FILE")

# '|| true' ensures set -e does not crash the script if 0 failed logins are found
FAILED_LOGINS=$(grep -c "Failed password" "$LOG_FILE" || true)

# 4. Generate structured incident triage summary
echo "=== SOC Log Triage Report ==="
echo "File Analyzed   : $LOG_FILE"
echo "Total Log Lines : $TOTAL_LINES"
echo "Failed Logins   : $FAILED_LOGINS"
