import torch
import torch.nn as nn
import torchvision.transforms as transforms
from torchvision import models
import tensorflow as tf
from tensorflow import keras
from PIL import Image
import numpy as np
import io
import base64
import cv2

# ========================
# PyTorch Model Definitions
# ========================

class SimpleCNN(nn.Module):
    """
    CNN Model - Matches the exact architecture from your training code
    Input: 128x128 RGB images
    Output: num_classes predictions
    """
    def __init__(self, num_classes=38):
        super(SimpleCNN, self).__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2)
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(128 * 16 * 16, 256),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(256, num_classes)
        )
    
    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x


# ========================
# Model Loading Functions
# ========================

def load_cnn_model(model_path, num_classes=38):
    """Load CNN model"""
    model = SimpleCNN(num_classes=num_classes)
    try:
        model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))
        model.eval()
        print(f"✓ CNN model loaded from {model_path}")
    except Exception as e:
        print(f"Warning: Could not load CNN weights: {e}")
        print("Using randomly initialized CNN model")
    return model


def load_mobilenet_model(model_path, num_classes=38):
    """Load MobileNetV2 model"""
    model = models.mobilenet_v2(pretrained=False)
    model.classifier[1] = nn.Linear(model.last_channel, num_classes)
    try:
        model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))
        model.eval()
        print(f"✓ MobileNetV2 model loaded from {model_path}")
    except Exception as e:
        print(f"Warning: Could not load MobileNetV2 weights: {e}")
        print("Using randomly initialized MobileNetV2 model")
    return model


def load_vit_model(model_path, num_classes=38):
    """
    Load Vision Transformer model using HuggingFace Transformers
    Matches the exact architecture from your training code
    """
    try:
        from transformers import ViTForImageClassification
        
        # Initialize model with correct architecture
        model = ViTForImageClassification.from_pretrained(
            "google/vit-base-patch16-224-in21k",
            num_labels=num_classes,
            ignore_mismatched_sizes=True
        )
        
        # Load trained weights if available
        try:
            state_dict = torch.load(model_path, map_location=torch.device('cpu'))
            model.load_state_dict(state_dict)
            print(f"✓ ViT model loaded from {model_path}")
        except Exception as e:
            print(f"Warning: Could not load ViT weights from {model_path}: {e}")
            print("Using pre-trained ViT model (fine-tuning weights not loaded)")
        
        model.eval()
        return model
        
    except ImportError:
        print("Error: transformers library not installed. Installing...")
        import subprocess
        subprocess.check_call(['pip', 'install', 'transformers'])
        from transformers import ViTForImageClassification
        
        model = ViTForImageClassification.from_pretrained(
            "google/vit-base-patch16-224-in21k",
            num_labels=num_classes,
            ignore_mismatched_sizes=True
        )
        model.eval()
        print("✓ ViT model initialized (transformers installed)")
        return model


def load_unet_model(model_path):
    """Load U-Net segmentation model"""
    try:
        model = keras.models.load_model(model_path)
        print(f"✓ U-Net model loaded from {model_path}")
        return model
    except Exception as e:
        print(f"Warning: Could not load U-Net model: {e}")
        print("Creating a new U-Net model")
        return create_unet_model()


def create_unet_model(input_shape=(128, 128, 3)):
    """
    U-Net model architecture - Matches the exact architecture from your training code
    Optimized version with fewer parameters for faster training
    """
    inputs = keras.layers.Input(input_shape)
    
    # Encoder (Downsampling path)
    c1 = keras.layers.Conv2D(32, 3, activation='relu', padding='same')(inputs)
    c1 = keras.layers.Conv2D(32, 3, activation='relu', padding='same')(c1)
    p1 = keras.layers.MaxPooling2D((2, 2))(c1)
    
    c2 = keras.layers.Conv2D(64, 3, activation='relu', padding='same')(p1)
    c2 = keras.layers.Conv2D(64, 3, activation='relu', padding='same')(c2)
    p2 = keras.layers.MaxPooling2D((2, 2))(c2)
    
    # Bottleneck
    b = keras.layers.Conv2D(128, 3, activation='relu', padding='same')(p2)
    b = keras.layers.Conv2D(128, 3, activation='relu', padding='same')(b)
    
    # Decoder (Upsampling path)
    u2 = keras.layers.UpSampling2D((2, 2))(b)
    u2 = keras.layers.concatenate([u2, c2])
    c3 = keras.layers.Conv2D(64, 3, activation='relu', padding='same')(u2)
    c3 = keras.layers.Conv2D(64, 3, activation='relu', padding='same')(c3)
    
    u1 = keras.layers.UpSampling2D((2, 2))(c3)
    u1 = keras.layers.concatenate([u1, c1])
    c4 = keras.layers.Conv2D(32, 3, activation='relu', padding='same')(u1)
    c4 = keras.layers.Conv2D(32, 3, activation='relu', padding='same')(c4)
    
    # Output layer
    outputs = keras.layers.Conv2D(1, (1, 1), activation='sigmoid')(c4)
    
    model = keras.Model(inputs=[inputs], outputs=[outputs])
    return model


# ========================
# Preprocessing Functions
# ========================

def preprocess_cnn(image):
    """
    Preprocessing for CNN model
    - Resize to (128, 128)
    - Normalize: mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]
    """
    transform = transforms.Compose([
        transforms.Resize((128, 128)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
    ])
    return transform(image).unsqueeze(0)


def preprocess_mobilenet(image):
    """
    Preprocessing for MobileNetV2 model
    - Resize to (224, 224)
    - Normalize: mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]
    """
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    return transform(image).unsqueeze(0)


def preprocess_vit(image):
    """
    Preprocessing for Vision Transformer model
    - Resize to (224, 224)
    - Normalize: mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]
    """
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
    ])
    return transform(image).unsqueeze(0)


def preprocess_unet(image):
    """
    Preprocessing for U-Net model
    - Resize to (128, 128)
    - Rescale by 1/255.0
    """
    image = image.resize((128, 128))
    image_array = np.array(image) / 255.0
    return np.expand_dims(image_array, axis=0)


# ========================
# Prediction Functions
# ========================

def predict_classification(model, image_tensor, class_names, model_type="standard"):
    """
    Run prediction for classification models (CNN, MobileNetV2, ViT)
    
    Args:
        model: PyTorch model or HuggingFace model
        image_tensor: Preprocessed image tensor
        class_names: List of class names
        model_type: "standard" for CNN/MobileNetV2, "vit" for Vision Transformer
    
    Returns:
        tuple: (class_name, confidence_score)
    """
    with torch.no_grad():
        if model_type == "vit":
            # HuggingFace ViT returns a special output object
            outputs = model(image_tensor).logits
        else:
            # Standard PyTorch models
            outputs = model(image_tensor)
        
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
        confidence, predicted = torch.max(probabilities, 1)
        
        class_idx = predicted.item()
        class_name = class_names[class_idx] if class_idx < len(class_names) else f"Class_{class_idx}"
        confidence_score = f"{confidence.item() * 100:.2f}%"
        
    return class_name, confidence_score


def predict_segmentation(model, image_array, original_image):
    """Run prediction for U-Net segmentation model"""
    # Predict mask
    prediction = model.predict(image_array, verbose=0)
    mask = prediction[0, :, :, 0]
    
    # Calculate disease percentage
    threshold = 0.5
    binary_mask = (mask > threshold).astype(np.uint8)
    disease_percentage = (np.sum(binary_mask) / binary_mask.size) * 100
    
    # Convert mask to colored image for visualization
    mask_colored = (mask * 255).astype(np.uint8)
    mask_colored = cv2.applyColorMap(mask_colored, cv2.COLORMAP_JET)
    mask_colored = cv2.resize(mask_colored, original_image.size)
    
    # Convert to base64
    mask_pil = Image.fromarray(cv2.cvtColor(mask_colored, cv2.COLOR_BGR2RGB))
    buffered = io.BytesIO()
    mask_pil.save(buffered, format="PNG")
    mask_base64 = base64.b64encode(buffered.getvalue()).decode()
    
    return mask_base64, f"{disease_percentage:.2f}"


# ========================
# Disease Information
# ========================

# Common plant disease classes (adjust based on your training data)
DISEASE_CLASSES = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Blueberry___healthy',
    'Cherry_(including_sour)___Powdery_mildew',
    'Cherry_(including_sour)___healthy',
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn_(maize)___Common_rust_',
    'Corn_(maize)___Northern_Leaf_Blight',
    'Corn_(maize)___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Pepper,_bell___Bacterial_spot',
    'Pepper,_bell___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Raspberry___healthy',
    'Soybean___healthy',
    'Squash___Powdery_mildew',
    'Strawberry___Leaf_scab',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy'
]


def get_disease_suggestion(disease_name):
    """Get treatment advice for detected disease"""
    suggestions = {
        'healthy': 'Great! Your plant appears to be healthy. Continue regular care and monitoring.',
        'scab': 'Remove infected leaves and apply fungicide. Ensure good air circulation.',
        'rot': 'Remove infected parts immediately. Reduce watering and improve drainage. Apply copper-based fungicide.',
        'rust': 'Remove infected leaves. Apply fungicide and ensure plants are not overcrowded.',
        'blight': 'Remove and destroy infected plants. Apply fungicide preventatively. Avoid overhead watering.',
        'mildew': 'Improve air circulation. Apply sulfur-based or neem oil fungicide. Water at base of plants.',
        'spot': 'Remove infected leaves. Apply copper-based bactericide or fungicide. Practice crop rotation.',
        'mold': 'Improve ventilation. Reduce humidity. Apply fungicide if necessary.',
        'virus': 'Remove and destroy infected plants to prevent spread. Control insect vectors. No cure available.',
        'mites': 'Spray with water to remove mites. Apply insecticidal soap or neem oil. Introduce predatory mites.',
        'default': 'Consult with a local agricultural extension office for specific treatment recommendations.'
    }
    
    disease_lower = disease_name.lower()
    
    if 'healthy' in disease_lower:
        return suggestions['healthy']
    
    for key, suggestion in suggestions.items():
        if key in disease_lower:
            return suggestion
    
    return suggestions['default']
