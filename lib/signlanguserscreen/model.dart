import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelHandler {
  Interpreter? _interpreter; // ✅ Nullable instead of late
  bool _isModelLoaded = false;
  final int inputSize = 224;

  bool get isModelLoaded => _isModelLoaded;

  ModelHandler();

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/signmodel.tflite');
      _isModelLoaded = true;
      print("✅ Model loaded successfully!");
    } catch (e) {
      _isModelLoaded = false;
      print("❌ Error loading model: $e");
    }
  }

  Future<String> predictSign(File imageFile) async {
    if (_interpreter == null) {
      // ✅ Prevent access before loading
      return "Error: Model is not loaded yet!";
    }

    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Invalid image format");

      img.Image resizedImage =
          img.copyResize(image, width: inputSize, height: inputSize);

      List<List<List<double>>> inputImage = List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            int pixel = resizedImage.getPixel(x, y);
            return <double>[
              img.getRed(pixel).toDouble() / 255.0,
              img.getGreen(pixel).toDouble() / 255.0,
              img.getBlue(pixel).toDouble() / 255.0,
            ];
          },
        ),
      );

      var inputTensor = [inputImage];
      var outputTensor = List.generate(1, (_) => List.filled(29, 0.0));

      _interpreter!
          .run(inputTensor, outputTensor); // ✅ Use null check before calling

      return _getBestPrediction(outputTensor);
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  String _getBestPrediction(List<List<double>> outputTensor) {
    List<String> labels = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
      "Space",
      "Nothing",
      "Del"
    ];

    List<double> probabilities = outputTensor[0];
    int predictedIndex =
        probabilities.indexWhere((val) => val == probabilities.reduce(max));
    double confidence = probabilities[predictedIndex] * 100;

    return predictedIndex < labels.length
        ? "Detected Sign: ${labels[predictedIndex]} (Accuracy: ${confidence.toStringAsFixed(2)}%)"
        : "Unknown Sign";
  }

  void dispose() {
    _interpreter?.close();
  }
}
