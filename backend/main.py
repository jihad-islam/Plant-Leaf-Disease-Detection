from fastapi import FastAPI, File, UploadFile, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from PIL import Image
import io
import os
from model_utils import (
    load_cnn_model, load_mobilenet_model, load_vit_model, load_unet_model,
    preprocess_cnn, preprocess_mobilenet, preprocess_vit, preprocess_unet,
    predict_classification, predict_segmentation,
    DISEASE_CLASSES, get_disease_suggestion
)

# Initialize FastAPI app
app = FastAPI(
    title="Plant Leaf Disease Detection API",
    description="API for detecting plant diseases using multiple AI models",
    version="1.0.0"
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # React app URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for models
models = {}

# Model paths (adjust these paths based on where you save your trained models)
MODEL_PATHS = {
    'CNN': 'models/cnn_model.pth',
    'MobileNetV2': 'models/mobilenet_model.pth',
    'ViT': 'models/vit_model.pth',
    'U-Net': 'models/unet_model.h5'
}


@app.on_event("startup")
async def load_models():
    """Load all models when the server starts"""
    print("=" * 50)
    print("Loading AI Models...")
    print("=" * 50)
    
    # Create models directory if it doesn't exist
    os.makedirs('models', exist_ok=True)
    
    # Load PyTorch models
    try:
        models['CNN'] = load_cnn_model(MODEL_PATHS['CNN'])
    except Exception as e:
        print(f"Error loading CNN: {e}")
        models['CNN'] = None
    
    try:
        models['MobileNetV2'] = load_mobilenet_model(MODEL_PATHS['MobileNetV2'])
    except Exception as e:
        print(f"Error loading MobileNetV2: {e}")
        models['MobileNetV2'] = None
    
    try:
        models['ViT'] = load_vit_model(MODEL_PATHS['ViT'])
    except Exception as e:
        print(f"Error loading ViT: {e}")
        models['ViT'] = None
    
    # Load TensorFlow model
    try:
        models['U-Net'] = load_unet_model(MODEL_PATHS['U-Net'])
    except Exception as e:
        print(f"Error loading U-Net: {e}")
        models['U-Net'] = None
    
    print("=" * 50)
    print("Models loaded successfully!")
    print("=" * 50)


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Plant Leaf Disease Detection API",
        "version": "1.0.0",
        "endpoints": {
            "/predict": "POST - Predict disease from leaf image",
            "/models": "GET - List available models",
            "/health": "GET - Check API health"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "models_loaded": {
            model_name: model is not None
            for model_name, model in models.items()
        }
    }


@app.get("/models")
async def list_models():
    """List available models"""
    return {
        "available_models": list(models.keys()),
        "model_status": {
            model_name: "loaded" if model is not None else "not loaded"
            for model_name, model in models.items()
        }
    }


@app.post("/predict")
async def predict_disease(
    file: UploadFile = File(...),
    model_name: str = Form(...)
):
    """
    Predict plant disease from uploaded leaf image
    
    Parameters:
    - file: Image file (JPEG, PNG)
    - model_name: Name of the model to use (CNN, MobileNetV2, ViT, U-Net)
    
    Returns:
    - For classification models: disease class, confidence score, and treatment suggestion
    - For U-Net: segmentation mask image and disease percentage
    """
    
    # Validate model name
    if model_name not in models:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid model name. Available models: {list(models.keys())}"
        )
    
    # Check if model is loaded
    if models[model_name] is None:
        raise HTTPException(
            status_code=503,
            detail=f"Model {model_name} is not loaded. Please check server logs."
        )
    
    # Validate file type
    if not file.content_type.startswith('image/'):
        raise HTTPException(
            status_code=400,
            detail="File must be an image (JPEG, PNG, etc.)"
        )
    
    try:
        # Read and open image
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data)).convert('RGB')
        
        # Process based on model type
        if model_name == 'U-Net':
            # Segmentation
            preprocessed = preprocess_unet(image)
            mask_base64, disease_percentage = predict_segmentation(
                models[model_name],
                preprocessed,
                image
            )
            
            return JSONResponse({
                "model": model_name,
                "type": "segmentation",
                "mask_image": mask_base64,
                "disease_percentage": disease_percentage
            })
        
        else:
            # Classification (CNN, MobileNetV2, ViT)
            if model_name == 'CNN':
                preprocessed = preprocess_cnn(image)
                model_type = "standard"
            elif model_name == 'MobileNetV2':
                preprocessed = preprocess_mobilenet(image)
                model_type = "standard"
            elif model_name == 'ViT':
                preprocessed = preprocess_vit(image)
                model_type = "vit"
            
            class_name, confidence = predict_classification(
                models[model_name],
                preprocessed,
                DISEASE_CLASSES,
                model_type=model_type
            )
            
            # Get treatment suggestion
            suggestion = get_disease_suggestion(class_name)
            
            return JSONResponse({
                "model": model_name,
                "type": "classification",
                "class": class_name,
                "confidence": confidence,
                "suggestion": suggestion
            })
    
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error processing image: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
