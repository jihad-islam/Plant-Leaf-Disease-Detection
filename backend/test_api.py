"""
Example script to test the API with a sample image
"""
import requests
import sys

def test_predict(image_path, model_name):
    """Test the /predict endpoint"""
    
    url = "http://localhost:8000/predict"
    
    try:
        with open(image_path, 'rb') as f:
            files = {'file': f}
            data = {'model_name': model_name}
            
            print(f"\nTesting {model_name} model with {image_path}...")
            print("-" * 50)
            
            response = requests.post(url, files=files, data=data)
            
            if response.status_code == 200:
                result = response.json()
                print(f"✓ Success!")
                print(f"Model: {result['model']}")
                print(f"Type: {result['type']}")
                
                if result['type'] == 'classification':
                    print(f"Disease: {result['class']}")
                    print(f"Confidence: {result['confidence']}")
                    print(f"Suggestion: {result['suggestion']}")
                else:
                    print(f"Disease Percentage: {result['disease_percentage']}%")
                    print(f"Mask Image: [base64 data]")
            else:
                print(f"✗ Error: {response.status_code}")
                print(response.json())
                
    except FileNotFoundError:
        print(f"Error: Image file not found: {image_path}")
    except requests.exceptions.ConnectionError:
        print("Error: Could not connect to backend server.")
        print("Make sure the backend is running on http://localhost:8000")
    except Exception as e:
        print(f"Error: {e}")

def test_health():
    """Test the /health endpoint"""
    try:
        response = requests.get("http://localhost:8000/health")
        if response.status_code == 200:
            print("\n✓ Backend is healthy")
            result = response.json()
            print(f"Status: {result['status']}")
            print("Models loaded:")
            for model, loaded in result['models_loaded'].items():
                status = "✓" if loaded else "✗"
                print(f"  {status} {model}")
        else:
            print(f"✗ Health check failed: {response.status_code}")
    except requests.exceptions.ConnectionError:
        print("✗ Could not connect to backend server")
        print("Make sure the backend is running on http://localhost:8000")

if __name__ == "__main__":
    # Test health first
    test_health()
    
    # Test prediction if image path provided
    if len(sys.argv) > 1:
        image_path = sys.argv[1]
        model_name = sys.argv[2] if len(sys.argv) > 2 else "CNN"
        test_predict(image_path, model_name)
    else:
        print("\nUsage: python test_api.py <image_path> [model_name]")
        print("Example: python test_api.py ../sources/sample1.jpg CNN")
        print("\nAvailable models: CNN, MobileNetV2, ViT, U-Net")
