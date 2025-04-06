import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo3.png"),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.email_outlined,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
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
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      ))
          .user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": _emailTextController.text,
          "username": _userNameTextController.text,
          "userType": _selectedUserType,
          "createdAt": Timestamp.now(),
        });

        _hideLoadingDialog();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _hideLoadingDialog();

      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use. Please try another one.';
      } else if (e.code == 'weak-password') {
        errorMessage =
            'Your password is too weak. Please choose a stronger one.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email you entered is invalid.';
      } else {
        errorMessage = 'Something went wrong. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      _hideLoadingDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
