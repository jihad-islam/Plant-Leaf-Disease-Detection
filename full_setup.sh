#!/bin/bash

# ============================================
# Complete Project Setup Script
# ============================================

set -e  # Exit on any error

echo "========================================="
echo "Plant Disease Detection - Full Setup"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get project root directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"

echo "Project directory: $PROJECT_DIR"
echo ""

# ============================================
# Step 1: Check Python Version
# ============================================
echo -e "${YELLOW}Step 1: Checking Python version...${NC}"

# Try to find suitable Python version (3.11 or 3.12)
PYTHON_CMD=""

for cmd in python3.12 python3.11 python3.10 python3.9 python3; do
    if command -v $cmd &> /dev/null; then
        VERSION=$($cmd --version 2>&1 | awk '{print $2}')
        MAJOR=$(echo $VERSION | cut -d. -f1)
        MINOR=$(echo $VERSION | cut -d. -f2)
        
        if [ "$MAJOR" = "3" ] && [ "$MINOR" -ge "9" ] && [ "$MINOR" -le "12" ]; then
            PYTHON_CMD=$cmd
            echo -e "${GREEN}✓ Found suitable Python: $cmd ($VERSION)${NC}"
            break
        fi
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}✗ Error: Python 3.9-3.12 not found!${NC}"
    echo "You are using Python 3.13 which has compatibility issues."
    echo "Please install Python 3.11 or 3.12:"
    echo "  sudo apt install python3.12 python3.12-venv"
    exit 1
fi

# ============================================
# Step 2: Setup Backend
# ============================================
echo ""
echo -e "${YELLOW}Step 2: Setting up backend...${NC}"

cd "$BACKEND_DIR"

# Remove old venv if exists
if [ -d "venv" ]; then
    echo "Removing old virtual environment..."
    rm -rf venv
fi

# Create new virtual environment with correct Python version
echo "Creating virtual environment with $PYTHON_CMD..."
$PYTHON_CMD -m venv venv

# Activate venv
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip setuptools wheel

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

echo -e "${GREEN}✓ Backend dependencies installed${NC}"

# Check if models directory has model files
echo ""
echo "Checking for trained model files..."
MODEL_COUNT=0

if [ -f "models/cnn_model.pth" ]; then
    MODEL_COUNT=$((MODEL_COUNT+1))
    echo -e "${GREEN}✓ Found cnn_model.pth${NC}"
else
    echo -e "${YELLOW}⚠ Missing cnn_model.pth${NC}"
fi

if [ -f "models/mobilenet_model.pth" ]; then
    MODEL_COUNT=$((MODEL_COUNT+1))
    echo -e "${GREEN}✓ Found mobilenet_model.pth${NC}"
else
    echo -e "${YELLOW}⚠ Missing mobilenet_model.pth${NC}"
fi

if [ -f "models/vit_model.pth" ]; then
    MODEL_COUNT=$((MODEL_COUNT+1))
    echo -e "${GREEN}✓ Found vit_model.pth${NC}"
else
    echo -e "${YELLOW}⚠ Missing vit_model.pth${NC}"
fi

if [ -f "models/unet_model.h5" ]; then
    MODEL_COUNT=$((MODEL_COUNT+1))
    echo -e "${GREEN}✓ Found unet_model.h5${NC}"
else
    echo -e "${YELLOW}⚠ Missing unet_model.h5${NC}"
fi

if [ $MODEL_COUNT -eq 0 ]; then
    echo ""
    echo -e "${YELLOW}WARNING: No trained models found!${NC}"
    echo "The app will run with randomly initialized models (for testing only)."
    echo ""
    echo "To add your trained models, copy them to: $BACKEND_DIR/models/"
    echo "  - cnn_best_fold.pth → models/cnn_model.pth"
    echo "  - mobilenetv2_best_fold.pth → models/mobilenet_model.pth"
    echo "  - vit_model.pth → models/vit_model.pth (or pytorch_model.bin)"
    echo "  - unet_fold3.h5 → models/unet_model.h5"
    echo ""
    read -p "Press Enter to continue without models, or Ctrl+C to exit and add models first..."
fi

deactivate

# ============================================
# Step 3: Setup Frontend
# ============================================
echo ""
echo -e "${YELLOW}Step 3: Setting up frontend...${NC}"

cd "$FRONTEND_DIR"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js not found!${NC}"
    echo "Please install Node.js (v14 or higher): https://nodejs.org/"
    exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Install frontend dependencies
echo "Installing frontend dependencies..."
npm install

echo -e "${GREEN}✓ Frontend dependencies installed${NC}"

# ============================================
# Step 4: Create run scripts
# ============================================
echo ""
echo -e "${YELLOW}Step 4: Creating run scripts...${NC}"

# Create start script
cat > "$PROJECT_DIR/start.sh" << 'EOF'
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
EOF

chmod +x "$PROJECT_DIR/start.sh"

echo -e "${GREEN}✓ Created start.sh${NC}"

# ============================================
# Final Instructions
# ============================================
echo ""
echo "========================================="
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo "========================================="
echo ""
echo "To start the application, run:"
echo ""
echo "  cd $PROJECT_DIR"
echo "  ./start.sh"
echo ""
echo "Or manually:"
echo ""
echo "Terminal 1 (Backend):"
echo "  cd $BACKEND_DIR"
echo "  source venv/bin/activate"
echo "  python main.py"
echo ""
echo "Terminal 2 (Frontend):"
echo "  cd $FRONTEND_DIR"
echo "  npm start"
echo ""
echo "========================================="

if [ $MODEL_COUNT -eq 0 ]; then
    echo ""
    echo -e "${YELLOW}REMINDER: Add your trained models to:${NC}"
    echo "  $BACKEND_DIR/models/"
    echo ""
fi
