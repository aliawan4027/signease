import 'package:flutter/material.dart';
import 'package:sign_ease/utils/firebase_handler.dart';
import 'package:sign_ease/resuable_widgets/reusable_widget.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  String _selectedUserType = '';

  final FirebaseHandler _firebaseHandler = FirebaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              horizontal: MediaQuery.of(context).size.width > 600 ? 60 : 20,
              vertical: MediaQuery.of(context).size.height > 800 ? 80 : 20,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo3.png"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                reusableTextField(
                  "Enter Email Id",
                  Icons.email_outlined,
                  false,
                  _emailTextController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Select User Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: "Normal User",
                      groupValue: _selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value!;
                        });
                      },
                    ),
                    const Text("Normal User"),
                    Radio(
                      value: "Sign Language User",
                      groupValue: _selectedUserType,
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value!;
                        });
                      },
                    ),
                    const Text("Sign Language User"),
                  ],
                ),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, _registerUser,
                    buttonText: 'Sign Up'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _registerUser() async {
    if (_selectedUserType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a user type.")),
      );
      return;
    }

    _showLoadingDialog();
    try {
      await _firebaseHandler.signUp(
        _emailTextController.text,
        _passwordTextController.text,
      );

      // Save user data
      await _firebaseHandler.saveUserData(
        _emailTextController.text,
        {
          "email": _emailTextController.text,
          "username": _userNameTextController.text,
          "userType": _selectedUserType,
        },
      );

      _hideLoadingDialog();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (e) {
      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
