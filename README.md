# 🌱 Plant Leaf Disease Detection

An intelligent web application for automated plant disease diagnosis using deep learning. Upload a leaf image, select an AI model, and receive instant disease detection with treatment recommendations.

---

## ✨ Features

- 🎯 **Four AI Models**: CNN, MobileNetV2, Vision Transformer (ViT), U-Net
- 🌿 **38 Disease Classes**: Comprehensive coverage of common plant diseases
- 🖼️ **Image Segmentation**: Visual highlighting of affected areas (U-Net)
- 💊 **Treatment Recommendations**: Actionable advice for disease management
- 🎨 **Modern UI**: Clean, responsive interface with drag-and-drop upload
- ⚡ **Fast Inference**: Optimized for both CPU and GPU acceleration
- 📱 **Cross-Platform**: Works on Linux (Arch), Windows, and macOS

---

## 🚀 Quick Start

### Prerequisites

- **Python** 3.9-3.12 (⚠️ NOT 3.13)
- **Node.js** v14 or higher
- **npm** or **yarn**

### Installation (Arch Linux)

```bash
# Clone or navigate to project
cd /path/to/project

# Run automated setup
chmod +x full_setup.sh
./full_setup.sh

# Start application
./start.sh
```

### Installation (Windows)

```cmd
cd C:\path\to\project
setup.bat
run.bat
```

**For detailed setup instructions**, see **[SETUP_GUIDE.md](SETUP_GUIDE.md)**

---

## 📖 Usage

1. Open browser: `http://localhost:3000`
2. Upload a plant leaf image (JPG/PNG)
3. Select an AI model from the dropdown
4. Click **"Detect Disease"**
5. View results:
   - Disease name and confidence score
   - Treatment recommendations
   - Segmentation visualization (U-Net only)

---

## 🏗️ Project Structure

```
project/
├── backend/                  # FastAPI backend
│   ├── main.py              # API server
│   ├── model_utils.py       # Model architectures
│   ├── requirements.txt     # Python dependencies
│   └── models/              # Trained model files (.pth, .h5)
├── frontend/                # React frontend
│   ├── src/
│   │   ├── App.js          # Main component
│   │   └── api.js          # API client
│   └── package.json        # Node dependencies
├── full_setup.sh           # Automated setup (Linux)
├── start.sh                # Start script (Linux)
├── setup.bat               # Automated setup (Windows)
├── run.bat                 # Start script (Windows)
└── SETUP_GUIDE.md          # Detailed installation guide
```

---

## 🤖 AI Models

### 1. CNN (Custom)

- Simple 3-layer convolutional architecture
- **Best for:** Fast baseline predictions
- **Speed:** ⚡⚡⚡ Very Fast
- **Accuracy:** ⭐⭐⭐ Good

### 2. MobileNetV2

- Transfer learning from ImageNet
- **Best for:** Mobile and edge deployment
- **Speed:** ⚡⚡ Fast
- **Accuracy:** ⭐⭐⭐⭐ Very Good

### 3. Vision Transformer (ViT)

- Attention-based transformer architecture
- **Best for:** Highest accuracy requirements
- **Speed:** ⚡ Moderate
- **Accuracy:** ⭐⭐⭐⭐⭐ Excellent

### 4. U-Net

- Semantic segmentation model
- **Best for:** Visual disease localization
- **Speed:** ⚡⚡ Fast
- **Output:** Binary segmentation mask

---

## 🗂️ Adding Trained Models

The app requires trained model files to make accurate predictions.

### Expected Files

Place your trained models in `backend/models/`:

```
backend/models/
├── cnn_model.pth           # CNN weights
├── mobilenet_model.pth     # MobileNetV2 weights
├── vit_model.pth           # Vision Transformer weights
└── unet_model.h5           # U-Net weights
```

### Copy Models

**Linux:**

```bash
cp ~/Downloads/your_model.pth backend/models/cnn_model.pth
```

**Windows:**

```cmd
copy "%USERPROFILE%\Downloads\your_model.pth" "backend\models\cnn_model.pth"
```

**Restart backend** after adding models.

---

## 🔧 Troubleshooting

### Python Version Issues

```bash
# Check Python version
python3 --version

# Install Python 3.12 (Arch Linux)
yay -S python312
```

### Port Already in Use

```bash
# Linux
sudo lsof -ti:8000 | xargs kill -9  # Backend
sudo lsof -ti:3000 | xargs kill -9  # Frontend

# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Module Not Found

```bash
# Activate virtual environment
source backend/venv/bin/activate  # Linux
backend\venv\Scripts\activate     # Windows

# Reinstall dependencies
pip install -r requirements.txt
```

**For more troubleshooting**, see **[SETUP_GUIDE.md](SETUP_GUIDE.md#troubleshooting)**

---

## 🛠️ Tech Stack

### Backend

- **FastAPI** 0.104.1 - Modern async web framework
- **PyTorch** 2.5.1 - Deep learning framework
- **TensorFlow** 2.18.0 - Machine learning platform
- **Transformers** 4.35.2 - HuggingFace models
- **OpenCV** 4.8.1.78 - Image processing

### Frontend

- **React** 18.2.0 - UI library
- **Tailwind CSS** 3.3.5 - Utility-first CSS
- **Axios** 1.6.0 - HTTP client

---

## 📊 Disease Classes (38)

The models detect the following plant diseases:

- Apple: Scab, Black Rot, Cedar Rust, Healthy
- Blueberry: Healthy
- Cherry: Powdery Mildew, Healthy
- Corn: Gray Leaf Spot, Common Rust, Northern Leaf Blight, Healthy
- Grape: Black Rot, Esca, Leaf Blight, Healthy
- Orange: Huanglongbing (Citrus Greening)
- Peach: Bacterial Spot, Healthy
- Pepper: Bacterial Spot, Healthy
- Potato: Early Blight, Late Blight, Healthy
- Raspberry: Healthy
- Soybean: Healthy
- Squash: Powdery Mildew
- Strawberry: Leaf Scorch, Healthy
- Tomato: Bacterial Spot, Early Blight, Late Blight, Leaf Mold, Septoria Leaf Spot, Spider Mites, Target Spot, Yellow Leaf Curl Virus, Mosaic Virus, Healthy

---

## 📦 System Requirements

### Minimum

- **CPU:** Dual-core 2.0 GHz
- **RAM:** 4 GB
- **Storage:** 5 GB free
- **OS:** Linux, Windows 10+, macOS 10.15+

### Recommended

- **CPU:** Quad-core 2.5 GHz+
- **RAM:** 8 GB+
- **Storage:** 10 GB SSD
- **GPU:** CUDA-compatible (optional, for faster inference)

---

## 🌐 API Documentation

Once the backend is running, access interactive API docs:

- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`
- **Health Check:** `http://localhost:8000/health`

### Main Endpoint

**POST** `/predict`

**Request:**

- `file`: Image file (multipart/form-data)
- `model`: Model name (cnn/mobilenet/vit/unet)

**Response:**

```json
{
  "disease": "Tomato Late Blight",
  "confidence": 0.947,
  "recommendations": ["Remove infected plants", "Apply fungicide"],
  "segmentation_map": "base64_encoded_image"
}
```

---

## 🔐 Important Notes

- ⚠️ **Python 3.13 is NOT supported** - Use Python 3.9-3.12 only
- 🔒 Always use virtual environment to isolate dependencies
- 🎲 Without trained models, predictions will be random (demo mode)
- 🚀 GPU acceleration automatic if CUDA is available
- 📝 Check `SETUP_GUIDE.md` for platform-specific instructions

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open pull request

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- **Plant Village Dataset** - Training data
- **PyTorch & TensorFlow** - Deep learning frameworks
- **HuggingFace** - Transformers library
- **React & FastAPI** - Web frameworks

---

## 📞 Support

Need help? Check these resources:

1. 📖 **[Detailed Setup Guide](SETUP_GUIDE.md)** - Complete installation instructions
2. 🐛 **[Troubleshooting Section](SETUP_GUIDE.md#troubleshooting)** - Common issues and fixes
3. 📚 **[API Documentation](http://localhost:8000/docs)** - Interactive API reference

---

**Happy Plant Disease Detection!** 🌱🔍✨
