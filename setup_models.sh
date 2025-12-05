#!/bin/bash

# =====================================================
# Model Setup Script
# Copy and verify your trained models
# =====================================================

echo "=========================================="
echo "Plant Disease Detection - Model Setup"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Model directory
MODEL_DIR="backend/models"

# Check if model directory exists
if [ ! -d "$MODEL_DIR" ]; then
    echo -e "${RED}Error: Models directory not found${NC}"
    echo "Run this script from the project root directory"
    exit 1
fi

echo -e "${BLUE}This script will help you copy your trained models${NC}"
echo ""
echo "Required models:"
echo "  1. cnn_model.pth (CNN trained model)"
echo "  2. mobilenet_model.pth (MobileNetV2 trained model)"
echo "  3. vit_model.pth (Vision Transformer trained model)"
echo "  4. unet_model.h5 (U-Net segmentation model)"
echo ""

# Function to check if file exists
check_model() {
    local model_file=$1
    if [ -f "$MODEL_DIR/$model_file" ]; then
        local size=$(du -h "$MODEL_DIR/$model_file" | cut -f1)
        echo -e "${GREEN}✓ Found: $model_file ($size)${NC}"
        return 0
    else
        echo -e "${YELLOW}✗ Missing: $model_file${NC}"
        return 1
    fi
}

# Check existing models
echo -e "${BLUE}Checking existing models...${NC}"
echo ""

cnn_found=0
mobilenet_found=0
vit_found=0
unet_found=0

check_model "cnn_model.pth" && cnn_found=1
check_model "mobilenet_model.pth" && mobilenet_found=1
check_model "vit_model.pth" && vit_found=1
check_model "unet_model.h5" && unet_found=1

echo ""

# Count found models
total_found=$((cnn_found + mobilenet_found + vit_found + unet_found))

if [ $total_found -eq 4 ]; then
    echo -e "${GREEN}✓ All models found! ($total_found/4)${NC}"
    echo ""
    echo "Model Summary:"
    ls -lh "$MODEL_DIR"/*.pth "$MODEL_DIR"/*.h5 2>/dev/null
    echo ""
    echo -e "${GREEN}You're ready to run the application!${NC}"
    echo ""
    echo "Start the backend:"
    echo "  cd backend"
    echo "  source venv/bin/activate"
    echo "  python main.py"
    echo ""
    exit 0
fi

echo -e "${YELLOW}Found $total_found/4 models${NC}"
echo ""

# Interactive copy
echo -e "${BLUE}Would you like to copy models now? (y/n)${NC}"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Exiting. You can manually copy models later."
    echo ""
    echo "To copy manually:"
    echo "  cp /path/to/your/trained/models/*.pth $MODEL_DIR/"
    echo "  cp /path/to/your/trained/models/*.h5 $MODEL_DIR/"
    exit 0
fi

# Copy CNN model
if [ $cnn_found -eq 0 ]; then
    echo ""
    echo -e "${BLUE}Enter path to CNN model (cnn_best_fold.pth or similar):${NC}"
    read -r cnn_path
    if [ -f "$cnn_path" ]; then
        cp "$cnn_path" "$MODEL_DIR/cnn_model.pth"
        echo -e "${GREEN}✓ Copied CNN model${NC}"
    else
        echo -e "${RED}✗ File not found: $cnn_path${NC}"
    fi
fi

# Copy MobileNetV2 model
if [ $mobilenet_found -eq 0 ]; then
    echo ""
    echo -e "${BLUE}Enter path to MobileNetV2 model (mobilenetv2_best_fold.pth or similar):${NC}"
    read -r mobilenet_path
    if [ -f "$mobilenet_path" ]; then
        cp "$mobilenet_path" "$MODEL_DIR/mobilenet_model.pth"
        echo -e "${GREEN}✓ Copied MobileNetV2 model${NC}"
    else
        echo -e "${RED}✗ File not found: $mobilenet_path${NC}"
    fi
fi

# Copy ViT model
if [ $vit_found -eq 0 ]; then
    echo ""
    echo -e "${BLUE}Enter path to ViT model (.pth file):${NC}"
    read -r vit_path
    if [ -f "$vit_path" ]; then
        cp "$vit_path" "$MODEL_DIR/vit_model.pth"
        echo -e "${GREEN}✓ Copied ViT model${NC}"
    else
        echo -e "${RED}✗ File not found: $vit_path${NC}"
    fi
fi

# Copy U-Net model
if [ $unet_found -eq 0 ]; then
    echo ""
    echo -e "${BLUE}Enter path to U-Net model (unet_fold3.h5 or similar):${NC}"
    read -r unet_path
    if [ -f "$unet_path" ]; then
        cp "$unet_path" "$MODEL_DIR/unet_model.h5"
        echo -e "${GREEN}✓ Copied U-Net model${NC}"
    else
        echo -e "${RED}✗ File not found: $unet_path${NC}"
    fi
fi

# Final check
echo ""
echo -e "${BLUE}Verifying copied models...${NC}"
echo ""

check_model "cnn_model.pth"
check_model "mobilenet_model.pth"
check_model "vit_model.pth"
check_model "unet_model.h5"

echo ""
echo "=========================================="
echo "Model setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update dependencies: cd backend && pip install -r requirements.txt"
echo "2. Start backend: python main.py"
echo "3. Start frontend: cd frontend && npm start"
echo ""
