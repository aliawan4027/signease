import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Controller to capture text input
  final TextEditingController _reportController = TextEditingController();

  // Method to send report to Firestore
  Future<void> _sendReport() async {
    String reportText = _reportController.text;

    if (reportText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('reports').add({
          'message': reportText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the text field after submission
        _reportController.clear();

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully')),
        );
      } catch (e) {
        // Handle error and show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting report: $e')),
        );
      }
    } else {
      // Show an error if the input is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Report'),
        backgroundColor: hexStringToColor("2986cc"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text field for entering the report message
            TextField(
              controller: _reportController,
              decoration: const InputDecoration(
                labelText: 'Enter your report message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: _sendReport,
              child: const Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hexStringToColor("2986cc"),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: hexStringToColor("ffffff"),
    );
  }
}
