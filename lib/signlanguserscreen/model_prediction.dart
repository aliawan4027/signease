import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_ease/signlanguserscreen/model.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:sign_ease/utils/cloudinary_service.dart';

class ModelPrediction extends StatefulWidget {
  const ModelPrediction({super.key});

  @override
  State<ModelPrediction> createState() => _ModelPredictionState();
}

class _ModelPredictionState extends State<ModelPrediction> {
  final ModelHandler _modelHandler = ModelHandler();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isModelLoaded = false;
  bool _isProcessing = false;
  String? _predictionResult;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _modelHandler.loadModel();
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      setState(() {
        _isModelLoaded = false;
      });
      print('Error loading model: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _predictionResult = null;
        _uploadedImageUrl = null;
      });
    }
  }

  Future<void> _captureImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _predictionResult = null;
        _uploadedImageUrl = null;
      });
    }
  }

  Future<void> _predictSign() async {
    if (_selectedImage == null || !_isModelLoaded) return;

    setState(() {
      _isProcessing = true;
      _predictionResult = null;
    });

    try {
      final result = await _modelHandler.predictSign(_selectedImage!);

      // Upload image to Cloudinary
      final cloudinaryUrl =
          await CloudinaryService.uploadImage(_selectedImage!);

      setState(() {
        _predictionResult = result;
        _uploadedImageUrl = cloudinaryUrl;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _predictionResult = 'Error: ${e.toString()}';
        _isProcessing = false;
      });
    }
  }

  void _resetPrediction() {
    setState(() {
      _selectedImage = null;
      _predictionResult = null;
      _uploadedImageUrl = null;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Language Prediction',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: hexStringToColor("2986cc"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("ffffff"),
              hexStringToColor("f0f0f0"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Status Section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _isModelLoaded
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _isModelLoaded ? Colors.green : Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isModelLoaded ? Icons.check_circle : Icons.error,
                      color: _isModelLoaded ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isModelLoaded
                          ? 'Model Loaded Successfully'
                          : 'Model Loading Failed',
                      style: TextStyle(
                        color: _isModelLoaded ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Image Selection Section
              if (_selectedImage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Selected Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          height: isWeb ? 300 : 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Prediction Result
                      if (_predictionResult != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Prediction Result:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _predictionResult!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_uploadedImageUrl != null)
                                Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Image uploaded to Cloudinary:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      _uploadedImageUrl!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isProcessing ? null : _predictSign,
                            icon: _isProcessing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                                _isProcessing ? 'Processing...' : 'Predict'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _resetPrediction,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Image Selection Buttons
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _captureImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Select an image from gallery or capture from camera',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2. Click "Predict" to analyze the sign language gesture',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '3. View the prediction result',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '4. Images are automatically uploaded to Cloudinary',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
