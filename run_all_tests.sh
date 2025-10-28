#!/bin/bash
# Shell script to run all Robot Framework tests on Linux/macOS
# This script creates a results directory and executes all test suites

echo "===================================="
echo "  Robot Framework Test Execution"
echo "===================================="
echo ""

# Check if Robot Framework is installed
if ! command -v robot &> /dev/null
then
    echo "ERROR: Robot Framework is not installed!"
    echo "Please run: pip install -r requirements.txt"
    exit 1
fi

# Create results directory if it doesn't exist
mkdir -p results

echo "Running all test suites..."
echo ""

# Run all tests and generate reports
robot --outputdir results --timestampoutputs --name "API Test Suite" tests/

echo ""
echo "===================================="
echo "  Test Execution Completed"
echo "===================================="
echo ""
echo "Reports generated in: results/"
echo "- report.html (Test execution report)"
echo "- log.html (Detailed execution log)"
echo "- output.xml (XML output)"
echo ""

# Open the report in default browser (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    open results/report.html
# Open the report in default browser (Linux)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open results/report.html
fi

