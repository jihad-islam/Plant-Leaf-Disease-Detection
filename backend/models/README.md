# Models Directory

Place your trained model files here:

## Required Files:

1. **cnn_model.pth** - Your trained CNN model (PyTorch)

   - Input size: 128×128
   - Normalization: mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]

2. **mobilenet_model.pth** - Your trained MobileNetV2 model (PyTorch)

   - Input size: 224×224
   - Normalization: mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]

3. **vit_model.pth** - Your trained Vision Transformer model (PyTorch)

   - Input size: 224×224
   - Normalization: mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5]

4. **unet_model.h5** - Your trained U-Net segmentation model (TensorFlow/Keras)
   - Input size: 128×128
   - Preprocessing: Rescale by 1/255.0

## Notes:

- The application will work without these files but will use randomly initialized models
- For production use, you MUST provide properly trained models
- Model files are excluded from git (see .gitignore) due to their large size
- Consider using Git LFS or cloud storage for model versioning
