import { useState } from "react";
import "./App.css";
import { predictDisease } from "./api";

function App() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);
  const [modelName, setModelName] = useState("CNN");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);
  const [error, setError] = useState(null);

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
      setPreviewUrl(URL.createObjectURL(file));
      setResult(null);
      setError(null);
    }
  };

  const handleModelChange = (e) => {
    setModelName(e.target.value);
    setResult(null);
  };

  const handleDetect = async () => {
    if (!selectedFile) {
      setError("Please upload an image first");
      return;
    }

    setLoading(true);
    setError(null);
    setResult(null);

    try {
      const data = await predictDisease(selectedFile, modelName);
      setResult(data);
    } catch (err) {
      setError(
        err.response?.data?.detail ||
          "Error detecting disease. Please try again."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen py-8 px-4">
      <div className="max-w-6xl mx-auto">
        {/* Header Card */}
        <div className="bg-white rounded-2xl shadow-lg p-8 mb-8 text-center border-t-4 border-primary-green">
          <div className="flex items-center justify-center mb-4">
            <svg
              className="w-12 h-12 text-primary-green mr-3"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
              />
            </svg>
            <h1 className="text-4xl font-bold text-gray-800">
              Plant Leaf Disease Detection
            </h1>
          </div>
          <p className="text-gray-600 text-lg">
            Upload a leaf image and select a model to detect plant diseases
            using AI
          </p>
        </div>

        {/* Main Content */}
        <div className="bg-white rounded-2xl shadow-lg p-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            {/* Left Side - Upload and Controls */}
            <div>
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">
                Upload Image
              </h2>

              {/* File Upload Box */}
              <div className="border-4 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-primary-green transition-colors duration-300 mb-6">
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleFileChange}
                  className="hidden"
                  id="file-upload"
                />
                <label htmlFor="file-upload" className="cursor-pointer">
                  {previewUrl ? (
                    <div>
                      <img
                        src={previewUrl}
                        alt="Preview"
                        className="max-h-64 mx-auto rounded-lg shadow-md mb-4"
                      />
                      <p className="text-sm text-gray-600">
                        Click to change image
                      </p>
                    </div>
                  ) : (
                    <div>
                      <svg
                        className="w-16 h-16 mx-auto text-gray-400 mb-4"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth="2"
                          d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                        />
                      </svg>
                      <p className="text-gray-600 font-medium mb-2">
                        Click to upload leaf image
                      </p>
                      <p className="text-sm text-gray-500">
                        PNG, JPG, JPEG (Max. 10MB)
                      </p>
                    </div>
                  )}
                </label>
              </div>

              {/* Model Selection */}
              <div className="mb-6">
                <label className="block text-lg font-semibold text-gray-800 mb-3">
                  Select AI Model
                </label>
                <select
                  value={modelName}
                  onChange={handleModelChange}
                  className="w-full p-4 border-2 border-gray-300 rounded-xl focus:border-primary-green focus:outline-none text-lg transition-colors duration-300"
                >
                  <option value="CNN">
                    CNN - Convolutional Neural Network
                  </option>
                  <option value="MobileNetV2">
                    MobileNetV2 - Efficient CNN
                  </option>
                  <option value="ViT">ViT - Vision Transformer</option>
                  <option value="U-Net">U-Net - Segmentation Model</option>
                </select>
              </div>

              {/* Detect Button */}
              <button
                onClick={handleDetect}
                disabled={loading || !selectedFile}
                className={`w-full py-4 rounded-xl text-white text-xl font-bold shadow-lg transition-all duration-300 ${
                  loading || !selectedFile
                    ? "bg-gray-400 cursor-not-allowed"
                    : "bg-primary-green hover:bg-dark-green hover:shadow-xl transform hover:-translate-y-1"
                }`}
              >
                {loading ? (
                  <span className="flex items-center justify-center">
                    <svg
                      className="animate-spin h-6 w-6 mr-3"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                        fill="none"
                      />
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      />
                    </svg>
                    Detecting...
                  </span>
                ) : (
                  "🔍 Detect Disease"
                )}
              </button>

              {/* Error Message */}
              {error && (
                <div className="mt-4 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg">
                  <p className="font-medium">{error}</p>
                </div>
              )}
            </div>

            {/* Right Side - Results */}
            <div>
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">
                Results
              </h2>

              {!result ? (
                <div className="border-2 border-gray-200 rounded-xl p-12 text-center h-full flex items-center justify-center">
                  <div>
                    <svg
                      className="w-24 h-24 mx-auto text-gray-300 mb-4"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth="2"
                        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                      />
                    </svg>
                    <p className="text-gray-400 text-lg">
                      Results will appear here after detection
                    </p>
                  </div>
                </div>
              ) : modelName === "U-Net" ? (
                // U-Net Segmentation Results
                <div className="space-y-6">
                  <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border-2 border-primary-green">
                    <h3 className="text-xl font-bold text-gray-800 mb-4">
                      Segmentation Analysis
                    </h3>

                    {/* Images Side by Side */}
                    <div className="grid grid-cols-2 gap-4 mb-4">
                      <div>
                        <p className="text-sm font-semibold text-gray-600 mb-2">
                          Original Image
                        </p>
                        <img
                          src={previewUrl}
                          alt="Original"
                          className="w-full rounded-lg shadow-md border-2 border-gray-200"
                        />
                      </div>
                      <div>
                        <p className="text-sm font-semibold text-gray-600 mb-2">
                          Segmented Image
                        </p>
                        <img
                          src={`data:image/png;base64,${result.mask_image}`}
                          alt="Segmented"
                          className="w-full rounded-lg shadow-md border-2 border-primary-green"
                        />
                      </div>
                    </div>

                    {/* Disease Percentage */}
                    <div className="bg-white rounded-lg p-4 shadow-md">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-gray-700 font-semibold">
                          Diseased Area:
                        </span>
                        <span className="text-2xl font-bold text-red-600">
                          {result.disease_percentage}%
                        </span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-4 overflow-hidden">
                        <div
                          className="bg-red-500 h-4 rounded-full transition-all duration-500"
                          style={{ width: `${result.disease_percentage}%` }}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              ) : (
                // Classification Results (CNN, MobileNetV2, ViT)
                <div className="space-y-6">
                  <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border-2 border-primary-green">
                    <h3 className="text-xl font-bold text-gray-800 mb-4">
                      Detection Results
                    </h3>

                    {/* Disease Name */}
                    <div className="mb-4">
                      <p className="text-sm font-semibold text-gray-600 mb-1">
                        Predicted Disease
                      </p>
                      <p className="text-3xl font-bold text-red-600">
                        {result.class}
                      </p>
                    </div>

                    {/* Confidence Score */}
                    <div className="mb-4">
                      <div className="flex items-center justify-between mb-2">
                        <p className="text-sm font-semibold text-gray-600">
                          Confidence Score
                        </p>
                        <p className="text-xl font-bold text-primary-green">
                          {result.confidence}
                        </p>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                        <div
                          className="bg-primary-green h-3 rounded-full transition-all duration-500"
                          style={{ width: result.confidence }}
                        />
                      </div>
                    </div>
                  </div>

                  {/* Suggestion/Advice */}
                  {result.suggestion && (
                    <div className="bg-blue-50 rounded-xl p-6 border-2 border-blue-300">
                      <h3 className="text-lg font-bold text-gray-800 mb-3 flex items-center">
                        <svg
                          className="w-6 h-6 mr-2 text-blue-600"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth="2"
                            d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                          />
                        </svg>
                        Treatment Advice
                      </h3>
                      <p className="text-gray-700 leading-relaxed">
                        {result.suggestion}
                      </p>
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center mt-8 text-gray-600">
          <p>Powered by AI Technology - {modelName} Model</p>
        </div>
      </div>
    </div>
  );
}

export default App;
