import axios from "axios";

const API_BASE_URL = "http://localhost:8000";

export const predictDisease = async (imageFile, modelName) => {
  try {
    const formData = new FormData();
    formData.append("file", imageFile);
    formData.append("model_name", modelName);

    const response = await axios.post(`${API_BASE_URL}/predict`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    return response.data;
  } catch (error) {
    console.error("Error predicting disease:", error);
    throw error;
  }
};
