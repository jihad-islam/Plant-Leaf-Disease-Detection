#!/bin/bash

# Script to run both backend and frontend servers

echo "=========================================="
echo "Starting Plant Leaf Disease Detection"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if setup was run
if [ ! -d "backend/venv" ]; then
    echo -e "${RED}Error: Virtual environment not found${NC}"
    echo "Please run: ./setup.sh first"
    exit 1
fi

if [ ! -d "frontend/node_modules" ]; then
    echo -e "${RED}Error: Node modules not found${NC}"
    echo "Please run: ./setup.sh first"
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Shutting down servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

# Start backend
echo "Starting Backend Server..."
cd backend
source venv/bin/activate
python main.py &
BACKEND_PID=$!
cd ..
echo -e "${GREEN}✓ Backend started (PID: $BACKEND_PID)${NC}"
echo ""

# Wait for backend to start
sleep 3

# Start frontend
echo "Starting Frontend Server..."
cd frontend
npm start &
FRONTEND_PID=$!
cd ..
echo -e "${GREEN}✓ Frontend started (PID: $FRONTEND_PID)${NC}"
echo ""

echo "=========================================="
echo -e "${GREEN}Servers are running!${NC}"
echo "=========================================="
echo ""
echo "Backend API:  http://localhost:8000"
echo "Frontend App: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for user interrupt
wait
