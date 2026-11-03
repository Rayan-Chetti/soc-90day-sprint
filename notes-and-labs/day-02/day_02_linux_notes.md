# Day 02 — Command-Line Arguments, Conditionals & Practical SOC Log Triage (SOC 90-Day Sprint)

**Date:** November 2–3, 2026  
**Completed Modules:** [LabEx Shell Skill Tree](https://labex.io/skilltrees) (Passing Arguments & Conditionals) + Real-World SOC Log Triage Automation

---

## 1. Core Concepts Mastered

| Parameter / Operator | Meaning in Bash | SOC & Incident Response Application |
| :--- | :--- | :--- |
| **`$0`** | Name of the executing script | Prints accurate usage instructions (e.g., `Usage: $0 <logfile>`). |
| **`$1`, `$2`, `$3`** | Positional command-line arguments | Passes indicators like target log files (`$1`) or suspicious IP addresses (`$2`). |
| **`$#`** | Total number of arguments passed | Enforces parameter validation (`if [ $# -eq 0 ]`) before proceeding with an investigation. |
| **`"$@"`** | All arguments passed as separate quoted strings | Loops over multiple log files or IPs without breaking on filenames containing spaces. |
| **`[ -f "$FILE" ]`** | Regular file existence test | Verifies evidence files exist before calling parsing utilities. |
| **`[ ! -f "$FILE" ]`** | Logical NOT with file existence test | Triggers an immediate exit if the target log file does not exist. |
| **`[ $# -eq 0 ]`** | Numeric equality comparison | Checks if argument count equals zero (`-eq`, `-gt`, `-lt`, `-ge`, `-le`). |
| **`command || true`** | Prevents exit on non-zero status | Guards against `set -e` terminating scripts when `grep -c` finds 0 matches. |

---

## 2. Production-Ready Lab Scripts

### Script 1: Positional Arguments & Argument Parsing (`arguments.sh`)

Demonstrates how Bash captures command-line parameters, validates counts, and iterates safely using `"$@"`.

```bash
#!/bin/bash
set -euo pipefail

# Part 1: Evaluating argument counts with if / elif / else
if [ $# -eq 0 ]; then
    echo "No arguments provided."
elif [ $# -eq 1 ]; then
    echo "One argument provided: $1"
elif [ $# -eq 2 ]; then
    echo "Two arguments provided: $1 and $2"
else
    echo "More than two arguments provided:"
    echo "First argument  : $1"
    echo "Second argument : $2"
    echo "Third argument  : $3"
    echo "Total arguments : $#"
fi

echo "----------------------------------------"

# Part 2: Iterating over all arguments safely using "$@"
echo "Total number of arguments: $#"
echo "All arguments:"
count=1
for arg in "$@"; do
    echo "Argument $count: $arg"
    count=$((count + 1))
done
```

---

### Script 2: Automated SOC Authentication Log Checker (`log_checker.sh`)

A defensive automation script that accepts a target authentication log path, validates its existence, extracts total line volume, and counts failed login attempts.

```bash
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
```

---

## 3. Test Verification & Expected Output

### Creating Sample Telemetry (`sample_auth.log`)

```bash
cat << 'EOF' > sample_auth.log
Nov  2 20:10:01 server sshd[101]: Accepted password for rayan from 192.168.1.10 port 51234 ssh2
Nov  2 20:11:15 server sshd[102]: Failed password for root from 185.220.101.4 port 44112 ssh2
Nov  2 20:11:18 server sshd[103]: Failed password for root from 185.220.101.4 port 44113 ssh2
Nov  2 20:12:02 server sshd[104]: Accepted password for admin from 10.0.0.5 port 55100 ssh2
Nov  2 20:13:44 server sshd[105]: Failed password for invalid user test from 91.240.118.22 port 39100 ssh2
EOF
```

### Execution Output

```text
$ ./log_checker.sh sample_auth.log
=== SOC Log Triage Report ===
File Analyzed   : sample_auth.log
Total Log Lines : 5
Failed Logins   : 3
```

---

## 4. Key Debugging Lessons & Edge Cases

1. **Mandatory Spacing Around `[`:** In POSIX shells, `[` is an executable binary (`/usr/bin/[`). Writing `[$#` or `0]` causes Bash to look for a non-existent command named `[0` or `0]`. Always maintain single spaces: `if [ $# -eq 0 ]; then`.
2. **The `set -e` vs. `grep -c` Trap:** When `grep -c` finds zero matching strings, it prints `0` but exits with status code `1`. Under `set -e`, this fatal-exits the script. Adding `|| true` guarantees clean execution when analyzing clean logs.
3. **Guard Against Empty Parameter Expansion:** Quoting `"$LOG_FILE"` prevents shell word-splitting and glob expansion when analyzing files with whitespace in their paths.
