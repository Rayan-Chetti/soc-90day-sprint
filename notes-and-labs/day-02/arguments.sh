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
