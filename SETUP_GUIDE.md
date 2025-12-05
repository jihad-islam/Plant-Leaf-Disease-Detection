# 🛠️ Detailed Setup Guide

Complete installation and setup instructions for **Plant Leaf Disease Detection** on Windows and Linux (Arch).

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Arch Linux Setup](#arch-linux-setup)
- [Windows Setup](#windows-setup)
- [Adding Trained Models](#adding-trained-models)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Common Requirements

- **Node.js** v14 or higher ([Download](https://nodejs.org/))
- **Python** 3.9 to 3.12 (⚠️ NOT 3.13 - has compatibility issues)
- **Git** (optional, for cloning)
- Minimum **4GB RAM** (8GB recommended)
- **5GB free disk space** (for dependencies)

---

## Arch Linux Setup

### Step 1: Install Python 3.12

```bash
# Check current Python version
python3 --version

# If you have Python 3.13, install Python 3.12
sudo pacman -S python

# If python3.12 is not available in official repos, use AUR
yay -S python312
# OR
paru -S python312

# Verify installation
python3.12 --version
# Should show: Python 3.12.x
```

### Step 2: Install Node.js and npm

```bash
# Install Node.js and npm
sudo pacman -S nodejs npm

# Verify installation
node --version
npm --version
```

### Step 3: Navigate to Project

```bash
cd /path/to/your/project
```

### Step 4: Run Automated Setup

```bash
# Make setup script executable (if not already)
chmod +x full_setup.sh

# Run the setup
./full_setup.sh
```

**What the script does:**

- ✅ Checks Python version
- ✅ Creates virtual environment with Python 3.12
- ✅ Installs all Python dependencies (PyTorch, TensorFlow, FastAPI, etc.)
- ✅ Installs all Node.js dependencies (React, Tailwind CSS, etc.)
- ✅ Checks for trained model files
- ✅ Creates start script

**Installation time:** 10-15 minutes (depending on internet speed)

### Step 5: Start the Application

```bash
# Start both backend and frontend
./start.sh
```

The application will:

- Start backend on `http://localhost:8000`
- Start frontend on `http://localhost:3000`
- Automatically open in your default browser

---

## Windows Setup

### Step 1: Install Python 3.12

1. **Download Python 3.12** from [python.org](https://www.python.org/downloads/)
2. Run the installer
3. ⚠️ **IMPORTANT:** Check "Add Python to PATH"
4. Choose "Customize installation"
5. Check "pip" and "py launcher"
6. Click "Install"

**Verify installation:**

```cmd
python --version
```

Should show: `Python 3.12.x`

### Step 2: Install Node.js

1. **Download Node.js** from [nodejs.org](https://nodejs.org/)
2. Run the installer
3. Accept all defaults
4. Click "Install"

**Verify installation:**

```cmd
node --version
npm --version
```

### Step 3: Navigate to Project

```cmd
cd C:\path\to\your\project
```

### Step 4: Run Setup Script

```cmd
setup.bat
```

**What the script does:**

- ✅ Creates virtual environment
- ✅ Installs Python dependencies
- ✅ Installs Node.js dependencies
- ✅ Checks for models

**Installation time:** 10-15 minutes

### Step 5: Start the Application

```cmd
run.bat
```

Or manually in two separate command prompts:

**Terminal 1 (Backend):**

```cmd
cd backend
venv\Scripts\activate
python main.py
```

**Terminal 2 (Frontend):**

```cmd
cd frontend
npm start
```

---

## Adding Trained Models

### Where to Get Models

Your trained models should be downloaded from Kaggle after running the training scripts. Look for these files in your Kaggle notebook outputs:

- `cnn_best_fold.pth` (CNN model)
- `mobilenetv2_best_fold.pth` (MobileNetV2 model)
- `vit_model.pth` or `pytorch_model.bin` (Vision Transformer)
- `unet_fold3.h5` (U-Net segmentation model)

### Copy Models to Project

**On Linux (Arch):**

```bash
# Create models directory if it doesn't exist
mkdir -p backend/models

# Copy your trained models
cp ~/Downloads/cnn_best_fold.pth backend/models/cnn_model.pth
cp ~/Downloads/mobilenetv2_best_fold.pth backend/models/mobilenet_model.pth
cp ~/Downloads/vit_model.pth backend/models/vit_model.pth
cp ~/Downloads/unet_fold3.h5 backend/models/unet_model.h5
```

**On Windows:**

```cmd
REM Copy models from Downloads folder
copy "%USERPROFILE%\Downloads\cnn_best_fold.pth" "backend\models\cnn_model.pth"
copy "%USERPROFILE%\Downloads\mobilenetv2_best_fold.pth" "backend\models\mobilenet_model.pth"
copy "%USERPROFILE%\Downloads\vit_model.pth" "backend\models\vit_model.pth"
copy "%USERPROFILE%\Downloads\unet_fold3.h5" "backend\models\unet_model.h5"
```

### Required Model Names

The backend expects these exact filenames:

- ✅ `cnn_model.pth`
- ✅ `mobilenet_model.pth`
- ✅ `vit_model.pth`
- ✅ `unet_model.h5`

### Restart Backend to Load Models

After copying models:

**Linux:**

```bash
# In backend terminal, press Ctrl+C, then:
source venv/bin/activate
python main.py
```

**Windows:**

```cmd
REM In backend terminal, press Ctrl+C, then:
venv\Scripts\activate
python main.py
```

You should see:

```
Loading models...
✓ CNN model loaded from models/cnn_model.pth
✓ MobileNetV2 model loaded from models/mobilenet_model.pth
✓ ViT model loaded from models/vit_model.pth
✓ U-Net model loaded from models/unet_model.h5
```

---

## Running the Application

### Quick Start (After Initial Setup)

**Linux:**

```bash
cd /path/to/project
./start.sh
```

**Windows:**

```cmd
cd C:\path\to\project
run.bat
```

### Manual Start (Two Terminals)

**Terminal 1 - Backend:**

_Linux:_

```bash
cd backend
source venv/bin/activate
python main.py
```

_Windows:_

```cmd
cd backend
venv\Scripts\activate
python main.py
```

**Terminal 2 - Frontend:**

_Linux:_

```bash
cd frontend
npm start
```

_Windows:_

```cmd
cd frontend
npm start
```

### Verify Everything is Running

1. **Backend Health Check:**

   - Open browser: `http://localhost:8000/health`
   - Should see: `{"status": "healthy"}`

2. **Frontend Check:**

   - Open browser: `http://localhost:3000`
   - Should see the Plant Disease Detection interface

3. **API Documentation:**
   - Open browser: `http://localhost:8000/docs`
   - See interactive API documentation

---

## Troubleshooting

### Python Version Issues

**Problem:** Script says "Python 3.9-3.12 not found"

**Solution:**

```bash
# Arch Linux:
yay -S python312

# Windows:
# Download and install Python 3.12 from python.org
```

### Port Already in Use

**Problem:** "Port 8000 already in use" or "Port 3000 already in use"

**Solution:**

_Linux:_

```bash
# Kill process on port 8000
sudo lsof -ti:8000 | xargs kill -9

# Kill process on port 3000
sudo lsof -ti:3000 | xargs kill -9
```

_Windows:_

```cmd
REM Kill process on port 8000
netstat -ano | findstr :8000
taskkill /PID <PID> /F

REM Kill process on port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Module Not Found Errors

**Problem:** "ModuleNotFoundError: No module named 'fastapi'" (or other modules)

**Solution:**

```bash
# Make sure virtual environment is activated
# You should see (venv) in your terminal

# Linux:
source backend/venv/bin/activate

# Windows:
backend\venv\Scripts\activate

# Reinstall dependencies
pip install -r requirements.txt
```

### Frontend Build Errors

**Problem:** "npm install" fails or shows errors

**Solution:**

```bash
# Clear cache and reinstall
cd frontend
rm -rf node_modules package-lock.json  # Linux
# OR
rmdir /s node_modules & del package-lock.json  # Windows

npm cache clean --force
npm install
```

### Model Loading Warnings

**Problem:** "Warning: Could not load CNN weights"

**Solution:** This is normal if you haven't added trained models yet. The app will work with randomly initialized models (predictions will be random). Add your trained models following the [Adding Trained Models](#adding-trained-models) section.

### TensorFlow/PyTorch Installation Issues

**Problem:** PyTorch or TensorFlow fails to install

**Solution:**

_For PyTorch:_

```bash
# Linux/Windows:
pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cpu
```

_For TensorFlow:_

```bash
pip install tensorflow==2.18.0
```

### Permission Denied (Linux)

**Problem:** "Permission denied" when running scripts

**Solution:**

```bash
# Make scripts executable
chmod +x full_setup.sh
chmod +x start.sh
```

### Virtual Environment Activation Issues (Windows)

**Problem:** "cannot be loaded because running scripts is disabled"

**Solution:**

```cmd
# Run PowerShell as Administrator and execute:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then try activating venv again
```

---

## System Requirements

### Minimum Requirements

- **CPU:** Dual-core 2.0 GHz
- **RAM:** 4 GB
- **Storage:** 5 GB free space
- **OS:**
  - Linux (Arch, Ubuntu, Debian, etc.)
  - Windows 10/11
  - macOS 10.15+

### Recommended Requirements

- **CPU:** Quad-core 2.5 GHz or better
- **RAM:** 8 GB or more
- **Storage:** 10 GB free space (SSD preferred)
- **GPU:** Optional (CUDA-compatible for faster inference)

---

## Getting Help

If you encounter issues not covered here:

1. Check the main [README.md](README.md) troubleshooting section
2. Verify all prerequisites are installed correctly
3. Make sure you're using Python 3.9-3.12 (not 3.13)
4. Check that both backend (port 8000) and frontend (port 3000) are running
5. Look for error messages in the terminal and search for solutions

---

**Happy Coding! 🌱**
