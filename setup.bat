@echo off
REM Script to set up the Plant Leaf Disease Detection project on Windows

echo ==========================================
echo Plant Leaf Disease Detection Setup
echo ==========================================
echo.

REM Check for Python
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed
    exit /b 1
)

REM Check for Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo Error: Node.js is not installed
    exit /b 1
)

echo All prerequisites found
echo.

REM Backend setup
echo ==========================================
echo Setting up Backend...
echo ==========================================
echo.

cd backend

REM Create virtual environment
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    echo Virtual environment created
) else (
    echo Virtual environment already exists
)

REM Activate virtual environment and install dependencies
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo.

echo Installing Python dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt
echo Python dependencies installed
echo.

REM Create models directory
if not exist "models" (
    echo Creating models directory...
    mkdir models
    echo Models directory created
    echo WARNING: Please place your trained model files in backend\models\
) else (
    echo Models directory already exists
)

echo.
cd ..

REM Frontend setup
echo ==========================================
echo Setting up Frontend...
echo ==========================================
echo.

cd frontend

echo Installing Node.js dependencies...
call npm install
echo Node.js dependencies installed
echo.

cd ..

REM Final instructions
echo ==========================================
echo Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo.
echo 1. Place your trained model files in: backend\models\
echo    - cnn_model.pth
echo    - mobilenet_model.pth
echo    - vit_model.pth
echo    - unet_model.h5
echo.
echo 2. To start the application, run:
echo    run.bat
echo.
echo    Or manually:
echo.
echo    Terminal 1 (Backend):
echo    cd backend
echo    venv\Scripts\activate
echo    python main.py
echo.
echo    Terminal 2 (Frontend):
echo    cd frontend
echo    npm start
echo.
echo 3. Open your browser at: http://localhost:3000
echo.
echo ==========================================
pause
