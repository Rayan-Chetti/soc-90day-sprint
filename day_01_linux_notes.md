# Day 01 — Linux & Bash Scripting Fundamentals (SOC 90-Day Sprint)

**Date:** November 1, 2026  
**Completed Modules:** [LabEx Shell Skill Tree](https://labex.io/skilltrees) (First Script & Shell Variables) + [GitHub Skills: Introduction to Git](https://github.com/skills/introduction-to-git)

## Core Concepts Mastered

| Concept | Syntax / Command | SOC & Incident Response Application |
| :--- | :--- | :--- |
| **Shebang & Strict Mode** | `#!/bin/bash` + `set -euo pipefail` | Ensures triage scripts fail safely on typos or missing variables instead of running destructive commands on empty paths. |
| **Execution Permissions** | `chmod +x script.sh` | Grants execution rights to custom incident collection scripts on live Linux hosts. |
| **Unambiguous Expansion** | `${VAR}suffix` | Prevents variable name collisions when building dynamic log filenames (e.g., `${HOST}_auth.log`). |
| **Whitespace Preservation** | `echo "$VAR"` vs `echo $VAR` | Preserves exact column spacing when parsing raw `syslog` or `auth.log` entries. |
| **Command Substitution** | `VAR=$(command)` | Captures live system telemetry (`date`, `uptime -p`, `who`, `ss -tulpn`) into variables for evidence reports. |
| **Arithmetic Expansion** | `$((X + Y))` | Counts failed SSH login thresholds or calculates alert frequencies in loop counters. |
| **Environment Scope** | `export VAR` / `unset VAR` | Passes API keys (VirusTotal, AbuseIPDB) securely to child processes without hardcoding them in plain text. |

## Production-Ready Lab Scripts (Bug-Fixed)

### 1. Variable Expansion & System Telemetry (`variables.sh`)

```bash
#!/bin/bash
set -euo pipefail

PRICE_PER_APPLE=5
MyFirstLetters=ABC
greeting='Hello                 world!'

# Escaping special characters
echo "The price of an Apple today is: \$HK $PRICE_PER_APPLE"

# Avoiding ambiguity with curly braces
echo "The first 10 letters in the alphabet: ${MyFirstLetters}DEFGHIJ"

# Preserving whitespace (unquoted vs quoted)
echo $greeting
echo "$greeting"

# Command substitution for system telemetry
CURRENT_DATE=$(date +"%Y-%m-%d")
echo "Today's date is: $CURRENT_DATE"

FILES_IN_DIR=$(ls)
echo "Files in the current directory:"
echo "$FILES_IN_DIR"

UPTIME=$(uptime -p)
echo "System uptime: $UPTIME"
```

### 2. Shell Arithmetic Operations (`arithmetic.sh`)

*Fix applied from Day 1 review: Corrected the decrement assignment from `X=$((Y - 1))` to `Y=$((Y - 1))` so `Y` updates properly.*

```bash
#!/bin/bash
set -euo pipefail

X=10
Y=5

# Addition
SUM=$((X + Y))
echo "Sum of $X and $Y is: $SUM"

# Subtraction
DIFF=$((X - Y))
echo "Difference between $X and $Y is: $DIFF"

# Multiplication
PRODUCT=$((X * Y))
echo "Product of $X and $Y is: $PRODUCT"

# Division
QUOTIENT=$((X / Y))
echo "Quotient of $X divided by $Y is: $QUOTIENT"

# Modulus (remainder)
REMAINDER=$((X % Y))
echo "Remainder of $X divided by $Y is: $REMAINDER"

# Increment
X=$((X + 1))
echo "After incrementing, X is now $X"

# Decrement (Fixed: assigns back to Y instead of X)
Y=$((Y - 1))
echo "After decrementing, Y is now $Y"
```

### 3. Environment Variables & Child Process Scope (`environment.sh`)

*Fix applied from Day 1 review: Fixed the final variable typo (`$MY_VARAIBLE` → `${MY_VARIABLE:-}`) and noted how `bash -c` inherits exported variables.*

```bash
#!/bin/bash
set -euo pipefail

# Displaying common environment variables
echo "Home directory: $HOME"
echo "Current user: ${LOGNAME:-$(whoami)}"
echo "Shell being used: $SHELL"
echo "Current PATH: $PATH"

# Creating and exporting a new environment variable
export MY_VARIABLE="Hello from my variable"
echo "My new variable: $MY_VARIABLE"

# Creating a child process to demonstrate variable inheritance
bash -c 'echo "MY_VARIABLE in child process: $MY_VARIABLE"'

# Removing the environment variable
unset MY_VARIABLE

# Using parameter expansion ${VAR:-} so strict mode (-u) safely prints empty when unset
echo "MY_VARIABLE after unsetting: ${MY_VARIABLE:-}"
```

## Lessons Learned & Debugging Log

1. **Caught CLI Typo (`bach` vs `bash`):** Identified `./environment.sh: line 12: bach: command not found` in terminal output and fixed the child shell invocation.
2. **Preventing Silent Variable Typos:** In standard Bash, echoing a misspelled variable (`$MY_VARAIBLE`) silently prints nothing, which can hide bugs during an investigation. Adding `set -u` at the top of every script forces Bash to alert immediately on undefined variable names.
3. **Variable Reassignment Discipline:** Verified that arithmetic decrements (`Y=$((Y - 1))`) assign back to the target variable rather than overwriting an adjacent counter.
