import 'package:flutter/material.dart';
import 'package:sign_ease/normaluserscreens/normaluser.dart';
import 'package:sign_ease/screens/signup_screen.dart';
import 'package:sign_ease/screens/options_screen.dart';
import 'package:sign_ease/resetingpasswordscreens/forgotpassword.dart';
import 'package:sign_ease/signlanguserscreen/signlanguser.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:sign_ease/resuable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                logoWidget("assets/images/logo3.png"),
                const SizedBox(height: 30),
                reusableTextField(
                  "Enter Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 5),
                signInSignUpButton(
                  context,
                  true,
                  _handleSignIn,
                  buttonText: 'SignIn',
                ),
                signUpOption(context),
                const SizedBox(height: 10),
                forgotPasswordOption(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Signing in..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSignIn() async {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      showLoadingDialog(context);
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );

        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          String userType = userDoc['userType'];
          Navigator.pop(context);

          if (userType == "Normal User") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NormalUser()),
            );
          } else if (userType == "Sign Language User") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignLangUser(
                        userName: '',
                        userEmail: '',
                        userId: '',
                      )),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid user type.")),
            );
          }
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "User data not found in Firestore.");
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        String message = '';
        if (e.code == 'user-not-found') {
          message = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          message = "Wrong password provided.";
        } else {
          message = e.message ?? "An error occurred";
        }
        Fluttertoast.showToast(msg: message);
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "An error occurred: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter both email and password.");
    }
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Color.fromARGB(255, 7, 130, 230)),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Color.fromARGB(255, 7, 130, 230),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector forgotPasswordOption(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPassword()),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(
          color: Color.fromARGB(255, 7, 130, 230),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
