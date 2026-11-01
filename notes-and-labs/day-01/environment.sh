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
