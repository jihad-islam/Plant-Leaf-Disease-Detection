#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "========================================="
echo "Starting Plant Disease Detection App"
echo "========================================="
echo ""

# Start backend
echo "Starting backend server..."
cd "$PROJECT_DIR/backend"
source venv/bin/activate
python main.py &
BACKEND_PID=$!
echo "Backend started (PID: $BACKEND_PID)"

# Wait for backend to start
sleep 3

# Start frontend
echo ""
echo "Starting frontend server..."
cd "$PROJECT_DIR/frontend"
npm start &
FRONTEND_PID=$!
echo "Frontend started (PID: $FRONTEND_PID)"

echo ""
echo "========================================="
echo "✓ Application is running!"
echo "========================================="
echo ""
echo "Backend:  http://localhost:8000"
echo "Frontend: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all servers"
echo ""

# Wait for interrupt
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM

wait
