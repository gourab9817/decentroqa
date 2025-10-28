@echo off
REM Batch script to run all Robot Framework tests on Windows
REM This script creates a results directory and executes all test suites

echo ====================================
echo   Robot Framework Test Execution
echo ====================================
echo.

REM Check if Robot Framework is installed
robot --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Robot Framework is not installed!
    echo Please run: pip install -r requirements.txt
    pause
    exit /b 1
)

REM Create results directory if it doesn't exist
if not exist "results" mkdir results

echo Running all test suites...
echo.

REM Run all tests and generate reports
robot --outputdir results --timestampoutputs --name "API Test Suite" tests/

echo.
echo ====================================
echo   Test Execution Completed
echo ====================================
echo.
echo Reports generated in: results\
echo - report.html (Test execution report)
echo - log.html (Detailed execution log)
echo - output.xml (XML output)
echo.

REM Open the report in default browser
start results\report.html

pause

