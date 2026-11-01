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
