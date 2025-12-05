@echo off
REM Script to run both backend and frontend servers on Windows

echo ==========================================
echo Starting Plant Leaf Disease Detection
echo ==========================================
echo.

REM Check if setup was run
if not exist "backend\venv" (
    echo Error: Virtual environment not found
    echo Please run: setup.bat first
    exit /b 1
)

if not exist "frontend\node_modules" (
    echo Error: Node modules not found
    echo Please run: setup.bat first
    exit /b 1
)

REM Start backend in new window
echo Starting Backend Server...
start "Backend Server" cmd /k "cd backend && venv\Scripts\activate && python main.py"
echo Backend started
echo.

REM Wait for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend in new window
echo Starting Frontend Server...
start "Frontend Server" cmd /k "cd frontend && npm start"
echo Frontend started
echo.

echo ==========================================
echo Servers are running!
echo ==========================================
echo.
echo Backend API:  http://localhost:8000
echo Frontend App: http://localhost:3000
echo.
echo Close the terminal windows to stop the servers
echo.
pause
