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
    <div className="min-h-screen py-4 sm:py-8 px-3 sm:px-4 lg:px-6">
      <div className="max-w-7xl mx-auto">
        {/* Header Card */}
        <div className="bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8 mb-6 sm:mb-8 text-center border-t-4 border-primary-green">
          <div className="flex flex-col sm:flex-row items-center justify-center mb-3 sm:mb-4">
            <svg
              className="w-10 h-10 sm:w-12 sm:h-12 text-primary-green mb-2 sm:mb-0 sm:mr-3"
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
            <h1 className="text-2xl sm:text-3xl lg:text-4xl font-bold text-gray-800">
              Plant Leaf Disease Detection
            </h1>
          </div>
          <p className="text-gray-600 text-sm sm:text-base lg:text-lg">
            Upload a leaf image and select a model to detect plant diseases
            using AI
          </p>
        </div>

        {/* Main Content */}
        <div className="bg-white rounded-xl sm:rounded-2xl shadow-lg p-4 sm:p-6 lg:p-8">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-8">
            {/* Left Side - Upload and Controls */}
            <div className="space-y-4 sm:space-y-6">
              <h2 className="text-xl sm:text-2xl font-semibold text-gray-800">
                Upload Image
              </h2>

              {/* File Upload Box */}
              <div className="border-3 sm:border-4 border-dashed border-gray-300 rounded-xl p-4 sm:p-6 lg:p-8 text-center hover:border-primary-green transition-colors duration-300">
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleFileChange}
                  className="hidden"
                  id="file-upload"
                />
                <label htmlFor="file-upload" className="cursor-pointer block">
                  {previewUrl ? (
                    <div className="space-y-2">
                      <div className="relative w-full max-w-sm mx-auto">
                        <img
                          src={previewUrl}
                          alt="Preview"
                          className="w-full h-48 sm:h-56 lg:h-64 object-contain rounded-lg shadow-md"
                        />
                      </div>
                      <p className="text-xs sm:text-sm text-gray-600">
                        Click to change image
                      </p>
                    </div>
                  ) : (
                    <div>
                      <svg
                        className="w-12 h-12 sm:w-16 sm:h-16 mx-auto text-gray-400 mb-3 sm:mb-4"
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
                      <p className="text-sm sm:text-base text-gray-600 font-medium mb-2">
                        Click to upload leaf image
                      </p>
                      <p className="text-xs sm:text-sm text-gray-500">
                        PNG, JPG, JPEG (Max. 10MB)
                      </p>
                    </div>
                  )}
                </label>
              </div>

              {/* Model Selection */}
              <div>
                <label className="block text-base sm:text-lg font-semibold text-gray-800 mb-2 sm:mb-3">
                  Select AI Model
                </label>
                <select
                  value={modelName}
                  onChange={handleModelChange}
                  className="w-full p-3 sm:p-4 border-2 border-gray-300 rounded-xl focus:border-primary-green focus:outline-none text-sm sm:text-base lg:text-lg transition-colors duration-300"
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
                className={`w-full py-3 sm:py-4 rounded-xl text-white text-base sm:text-lg lg:text-xl font-bold shadow-lg transition-all duration-300 ${
                  loading || !selectedFile
                    ? "bg-gray-400 cursor-not-allowed"
                    : "bg-primary-green hover:bg-dark-green hover:shadow-xl transform hover:-translate-y-1"
                }`}
              >
                {loading ? (
                  <span className="flex items-center justify-center">
                    <svg
                      className="animate-spin h-5 w-5 sm:h-6 sm:w-6 mr-2 sm:mr-3"
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
                <div className="p-3 sm:p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg">
                  <p className="text-sm sm:text-base font-medium">{error}</p>
                </div>
              )}
            </div>

            {/* Right Side - Results */}
            <div className="space-y-4 sm:space-y-6">
              <h2 className="text-xl sm:text-2xl font-semibold text-gray-800">
                Results
              </h2>

              {!result ? (
                <div className="border-2 border-gray-200 rounded-xl p-8 sm:p-12 text-center min-h-[300px] flex items-center justify-center">
                  <div>
                    <svg
                      className="w-16 h-16 sm:w-20 sm:h-20 lg:w-24 lg:h-24 mx-auto text-gray-300 mb-3 sm:mb-4"
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
                    <p className="text-gray-400 text-sm sm:text-base lg:text-lg">
                      Results will appear here after detection
                    </p>
                  </div>
                </div>
              ) : modelName === "U-Net" ? (
                // U-Net Segmentation Results
                <div className="space-y-4 sm:space-y-6">
                  <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4 sm:p-6 border-2 border-primary-green">
                    <h3 className="text-lg sm:text-xl font-bold text-gray-800 mb-3 sm:mb-4">
                      Segmentation Analysis
                    </h3>

                    {/* Images Side by Side */}
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4 mb-3 sm:mb-4">
                      <div>
                        <p className="text-xs sm:text-sm font-semibold text-gray-600 mb-2">
                          Original Image
                        </p>
                        <img
                          src={previewUrl}
                          alt="Original"
                          className="w-full h-40 sm:h-48 object-contain rounded-lg shadow-md border-2 border-gray-200 bg-white"
                        />
                      </div>
                      <div>
                        <p className="text-xs sm:text-sm font-semibold text-gray-600 mb-2">
                          Segmented Image
                        </p>
                        <img
                          src={`data:image/png;base64,${result.mask_image}`}
                          alt="Segmented"
                          className="w-full h-40 sm:h-48 object-contain rounded-lg shadow-md border-2 border-primary-green bg-white"
                        />
                      </div>
                    </div>

                    {/* Disease Percentage */}
                    <div className="bg-white rounded-lg p-3 sm:p-4 shadow-md">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm sm:text-base text-gray-700 font-semibold">
                          Diseased Area:
                        </span>
                        <span className="text-xl sm:text-2xl font-bold text-red-600">
                          {result.disease_percentage}%
                        </span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-3 sm:h-4 overflow-hidden">
                        <div
                          className="bg-red-500 h-3 sm:h-4 rounded-full transition-all duration-500"
                          style={{ width: `${result.disease_percentage}%` }}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              ) : (
                // Classification Results (CNN, MobileNetV2, ViT)
                <div className="space-y-4 sm:space-y-6">
                  <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4 sm:p-6 border-2 border-primary-green">
                    <h3 className="text-lg sm:text-xl font-bold text-gray-800 mb-3 sm:mb-4">
                      Detection Results
                    </h3>

                    {/* Disease Name */}
                    <div className="mb-3 sm:mb-4">
                      <p className="text-xs sm:text-sm font-semibold text-gray-600 mb-1 sm:mb-2">
                        Predicted Disease
                      </p>
                      <p className="text-lg sm:text-2xl lg:text-3xl font-bold text-red-600 break-words">
                        {result.class}
                      </p>
                    </div>

                    {/* Confidence Score */}
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <p className="text-xs sm:text-sm font-semibold text-gray-600">
                          Confidence Score
                        </p>
                        <p className="text-base sm:text-lg lg:text-xl font-bold text-primary-green">
                          {result.confidence}
                        </p>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2.5 sm:h-3 overflow-hidden">
                        <div
                          className="bg-primary-green h-2.5 sm:h-3 rounded-full transition-all duration-500"
                          style={{ width: result.confidence }}
                        />
                      </div>
                    </div>
                  </div>

                  {/* Suggestion/Advice */}
                  {result.suggestion && (
                    <div className="bg-blue-50 rounded-xl p-4 sm:p-6 border-2 border-blue-300">
                      <h3 className="text-base sm:text-lg font-bold text-gray-800 mb-2 sm:mb-3 flex items-center">
                        <svg
                          className="w-5 h-5 sm:w-6 sm:h-6 mr-2 text-blue-600 flex-shrink-0"
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
                      <p className="text-sm sm:text-base text-gray-700 leading-relaxed">
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
        <div className="text-center mt-6 sm:mt-8 text-gray-600">
          <p className="text-xs sm:text-sm">
            Powered by AI Technology - {modelName} Model
          </p>
        </div>
      </div>
    </div>
  );
}

export default App;
