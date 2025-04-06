import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sign_ease/signlanguserscreen/model.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class RecordGestureScreen extends StatefulWidget {
  @override
  _RecordGestureScreenState createState() => _RecordGestureScreenState();
}

class _RecordGestureScreenState extends State<RecordGestureScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  List<File> _images = [];
  List<String> _predictions = [];
  late ModelHandler _modelHandler;

  @override
  void initState() {
    super.initState();
    _modelHandler = ModelHandler();
    _loadModelAndCamera();
  }

  Future<void> _loadModelAndCamera() async {
    try {
      await _modelHandler.loadModel();
      setState(() {});
      _initializeCamera();
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController =
        CameraController(_cameras.first, ResolutionPreset.medium);
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _captureImage() async {
    if (!_modelHandler.isModelLoaded) {
      print("Model is not ready yet!");
      return;
    }
    if (!_cameraController.value.isInitialized) return;
    final XFile? pickedFile = await _cameraController.takePicture();
    if (pickedFile != null) {
      File newImage = File(pickedFile.path);
      setState(() => _images.add(newImage));
      _predictSign(newImage);
    }
  }

  Future<void> _predictSign(File imageFile) async {
    String prediction = await _modelHandler.predictSign(imageFile);
    if (prediction.isNotEmpty) {
      String extractedSign =
          prediction.split("(")[0].replaceAll("Detected Sign:", "").trim();
      setState(() => _predictions.add(extractedSign));
    }
  }

  void _deleteGesture(int index) {
    setState(() {
      if (_images.length > index) _images.removeAt(index);
      if (_predictions.length > index) _predictions.removeAt(index);
    });
  }

  void _addSpace() {
    setState(() => _predictions.add(" "));
  }

  void _sendPrediction() {
    if (_predictions.isNotEmpty) {
      String finalPrediction = _predictions.join("");
      Navigator.pop(context, finalPrediction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Gesture"),
        backgroundColor: hexStringToColor("2986cc"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? CameraPreview(_cameraController)
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Prediction: ${_predictions.join("")} ",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _showDeleteDialog(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Image.file(_images[index],
                            width: 100, height: 100, fit: BoxFit.cover),
                        if (_predictions.length > index)
                          Positioned(
                            bottom: 5,
                            left: 5,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Text(
                                _predictions[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                  _captureImage, Icons.camera_alt, Colors.blueAccent),
              if (_predictions.isNotEmpty)
                _buildIconButton(_addSpace, Icons.space_bar, Colors.orange),
              if (_predictions.isNotEmpty)
                _buildIconButton(_sendPrediction, Icons.send, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(VoidCallback onPressed, IconData icon, Color color) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 30),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this image?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                _deleteGesture(index);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _modelHandler.dispose();
    super.dispose();
  }
}
