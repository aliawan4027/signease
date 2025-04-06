import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_ease/resetingpasswordscreens/resetpassword.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class ResetCode extends StatefulWidget {
  const ResetCode({super.key});

  @override
  State<ResetCode> createState() => _ResetCodeState();
}

class _ResetCodeState extends State<ResetCode> {
  final TextEditingController _codeTextController = TextEditingController();
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("2986cc"),
        title: const Text('Enter Verification Code'),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
                hexStringToColor("ffffff"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.of(context).size.height * 0.2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Enter Verification Code",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 130, 230),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Enter Code",
                    Icons.code_outlined,
                    false,
                    _codeTextController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    child: const Text("Verify Code"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyCode() async {
    final code = _codeTextController.text;

    try {
      // Assuming you are using Firebase, the following code is a placeholder.
      // Firebase itself doesn't have direct support for verification code, so you might need to
      // implement this logic or use the Firebase Auth's password reset flow.

      // For demonstration purposes, the code is hardcoded as '123456'.
      if (code == "123456") {
        // Navigate to the ResetPassword screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResetPassword()),
        );
      } else {
        _showDialog("Verification Denied", "The code is incorrect.");
      }
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  // Function to show a dialog based on verification status
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title == "Verification Granted") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetPassword()),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Reusable text field widget
  Widget reusableTextField(String hintText, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 7, 130, 230)),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Color.fromARGB(255, 7, 130, 230).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
