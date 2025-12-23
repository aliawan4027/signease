import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SignEase - Version 2.0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Developed by: Muhammad Ali',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terms:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. This application is designed for communication between normal users and sign language users.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '2. Users must respect each other\'s communication preferences and methods.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '3. All user-generated content is subject to community guidelines.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '4. The app reserves the right to moderate content and suspend accounts that violate terms.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Report'),
        backgroundColor: hexStringToColor("2986cc"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Report Form Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: hexStringToColor("f8f9fa"),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: hexStringToColor("e9ecef")),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report an Issue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reportController,
                      decoration: const InputDecoration(
                        labelText: 'Enter your report message',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendReport,
                        child: const Text('Submit Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexStringToColor("2986cc"),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Terms and Conditions Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          _showTermsDialog(context);
                        },
                        child: const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 130, 230),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Developer Link at Bottom
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: hexStringToColor("f0f0f"),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'SignEase - Version 2.0',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _launchURL('https://personalportfolio12.vercel.app/');
                      },
                      child: const Text(
                        'Developer: Muhammad Ali',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: hexStringToColor("ffffff"),
    );
  }
}
