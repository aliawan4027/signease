import 'dart:io';
import 'ml_handler.dart';

class ModelHandler {
  MLHandler _mlHandler = MLHandler();
  bool _isModelLoaded = false;
  final int inputSize = 224;

  bool get isModelLoaded => _isModelLoaded;

  ModelHandler();

  Future<void> loadModel() async {
    try {
      await _mlHandler.loadModel();
      _isModelLoaded = true;
      print("✅ Model loaded successfully!");
    } catch (e) {
      _isModelLoaded = false;
      print("❌ Error loading model: $e");
    }
  }

  Future<String> predictSign(File imageFile) async {
    if (!_isModelLoaded) {
      return "Error: Model is not loaded yet!";
    }

    try {
      return await _mlHandler.predictSign(imageFile);
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  void dispose() {
    _mlHandler.dispose();
  }
}
