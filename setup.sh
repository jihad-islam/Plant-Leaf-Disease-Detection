#!/bin/bash

# Script to set up and run the Plant Leaf Disease Detection project

echo "=========================================="
echo "Plant Leaf Disease Detection Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "Checking prerequisites..."
echo ""

if ! command_exists python3; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    exit 1
fi

if ! command_exists node; then
    echo -e "${RED}Error: Node.js is not installed${NC}"
    exit 1
fi

if ! command_exists npm; then
    echo -e "${RED}Error: npm is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites found${NC}"
echo ""

# Backend setup
echo "=========================================="
echo "Setting up Backend..."
echo "=========================================="
echo ""

cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${YELLOW}Virtual environment already exists${NC}"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}"
echo ""

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
echo -e "${GREEN}✓ Python dependencies installed${NC}"
echo ""

# Create models directory
if [ ! -d "models" ]; then
    echo "Creating models directory..."
    mkdir -p models
    echo -e "${GREEN}✓ Models directory created${NC}"
    echo -e "${YELLOW}⚠ Please place your trained model files in backend/models/${NC}"
else
    echo -e "${YELLOW}Models directory already exists${NC}"
fi

echo ""
cd ..

# Frontend setup
echo "=========================================="
echo "Setting up Frontend..."
echo "=========================================="
echo ""

cd frontend

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install
echo -e "${GREEN}✓ Node.js dependencies installed${NC}"
echo ""

cd ..

# Final instructions
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo ""
echo "1. Place your trained model files in: backend/models/"
echo "   - cnn_model.pth"
echo "   - mobilenet_model.pth"
echo "   - vit_model.pth"
echo "   - unet_model.h5"
echo ""
echo "2. To start the application, run:"
echo -e "   ${YELLOW}./run.sh${NC}"
echo ""
echo "   Or manually:"
echo ""
echo "   Terminal 1 (Backend):"
echo "   $ cd backend"
echo "   $ source venv/bin/activate"
echo "   $ python main.py"
echo ""
echo "   Terminal 2 (Frontend):"
echo "   $ cd frontend"
echo "   $ npm start"
echo ""
echo "3. Open your browser at: http://localhost:3000"
echo ""
echo "=========================================="
