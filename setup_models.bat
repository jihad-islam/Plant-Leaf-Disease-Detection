@echo off
REM =====================================================
REM Model Setup Script for Windows
REM Copy and verify your trained models
REM =====================================================

echo ==========================================
echo Plant Disease Detection - Model Setup
echo ==========================================
echo.

set MODEL_DIR=backend\models

if not exist "%MODEL_DIR%" (
    echo Error: Models directory not found
    echo Run this script from the project root directory
    exit /b 1
)

echo This script will help you copy your trained models
echo.
echo Required models:
echo   1. cnn_model.pth (CNN trained model)
echo   2. mobilenet_model.pth (MobileNetV2 trained model)
echo   3. vit_model.pth (Vision Transformer trained model)
echo   4. unet_model.h5 (U-Net segmentation model)
echo.

REM Check existing models
echo Checking existing models...
echo.

set found=0

if exist "%MODEL_DIR%\cnn_model.pth" (
    echo [OK] Found: cnn_model.pth
    set /a found+=1
) else (
    echo [MISSING] cnn_model.pth
)

if exist "%MODEL_DIR%\mobilenet_model.pth" (
    echo [OK] Found: mobilenet_model.pth
    set /a found+=1
) else (
    echo [MISSING] mobilenet_model.pth
)

if exist "%MODEL_DIR%\vit_model.pth" (
    echo [OK] Found: vit_model.pth
    set /a found+=1
) else (
    echo [MISSING] vit_model.pth
)

if exist "%MODEL_DIR%\unet_model.h5" (
    echo [OK] Found: unet_model.h5
    set /a found+=1
) else (
    echo [MISSING] unet_model.h5
)

echo.
echo Found %found%/4 models
echo.

if %found% EQU 4 (
    echo All models found!
    echo.
    dir "%MODEL_DIR%\*.pth" "%MODEL_DIR%\*.h5"
    echo.
    echo You're ready to run the application!
    echo.
    echo Start the backend:
    echo   cd backend
    echo   venv\Scripts\activate
    echo   python main.py
    echo.
    goto :end
)

echo Would you like to copy models now? (Y/N)
set /p response=

if /i not "%response%"=="Y" (
    echo.
    echo Exiting. You can manually copy models later.
    echo.
    echo To copy manually:
    echo   copy C:\path\to\your\models\*.pth %MODEL_DIR%\
    echo   copy C:\path\to\your\models\*.h5 %MODEL_DIR%\
    goto :end
)

REM Copy models interactively
if not exist "%MODEL_DIR%\cnn_model.pth" (
    echo.
    echo Enter path to CNN model (cnn_best_fold.pth or similar):
    set /p cnn_path=
    if exist "%cnn_path%" (
        copy "%cnn_path%" "%MODEL_DIR%\cnn_model.pth"
        echo Copied CNN model
    ) else (
        echo File not found: %cnn_path%
    )
)

if not exist "%MODEL_DIR%\mobilenet_model.pth" (
    echo.
    echo Enter path to MobileNetV2 model (mobilenetv2_best_fold.pth or similar):
    set /p mobilenet_path=
    if exist "%mobilenet_path%" (
        copy "%mobilenet_path%" "%MODEL_DIR%\mobilenet_model.pth"
        echo Copied MobileNetV2 model
    ) else (
        echo File not found: %mobilenet_path%
    )
)

if not exist "%MODEL_DIR%\vit_model.pth" (
    echo.
    echo Enter path to ViT model (.pth file):
    set /p vit_path=
    if exist "%vit_path%" (
        copy "%vit_path%" "%MODEL_DIR%\vit_model.pth"
        echo Copied ViT model
    ) else (
        echo File not found: %vit_path%
    )
)

if not exist "%MODEL_DIR%\unet_model.h5" (
    echo.
    echo Enter path to U-Net model (unet_fold3.h5 or similar):
    set /p unet_path=
    if exist "%unet_path%" (
        copy "%unet_path%" "%MODEL_DIR%\unet_model.h5"
        echo Copied U-Net model
    ) else (
        echo File not found: %unet_path%
    )
)

echo.
echo Verifying copied models...
echo.

if exist "%MODEL_DIR%\cnn_model.pth" (echo [OK] cnn_model.pth) else (echo [MISSING] cnn_model.pth)
if exist "%MODEL_DIR%\mobilenet_model.pth" (echo [OK] mobilenet_model.pth) else (echo [MISSING] mobilenet_model.pth)
if exist "%MODEL_DIR%\vit_model.pth" (echo [OK] vit_model.pth) else (echo [MISSING] vit_model.pth)
if exist "%MODEL_DIR%\unet_model.h5" (echo [OK] unet_model.h5) else (echo [MISSING] unet_model.h5)

echo.
echo ==========================================
echo Model setup complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Update dependencies: cd backend ^&^& pip install -r requirements.txt
echo 2. Start backend: python main.py
echo 3. Start frontend: cd frontend ^&^& npm start
echo.

:end
pause
