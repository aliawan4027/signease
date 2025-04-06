import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexStringToColor("2986cc"),
        title: const Text('Reset Password'),
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
                    "Reset Password",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 130, 230),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "New Password",
                    Icons.lock_outline,
                    true,
                    _newPasswordController,
                  ),
                  const SizedBox(height: 20),
                  reusableTextField(
                    "Confirm Password",
                    Icons.lock_outline,
                    true,
                    _confirmPasswordController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text("Reset Password"),
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

  void _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showDialog(
          "Passwords Do Not Match", "Please re-enter the same password.");
      return;
    }
    try {
      await _auth.currentUser!.updatePassword(_newPasswordController.text);
      _showDialog("Success", "Password reset successful.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

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
                if (title == "Success") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (Route<dynamic> route) => false,
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
