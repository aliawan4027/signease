import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sign_ease/normaluserscreens/normaluser.dart';
import 'package:sign_ease/screens/signup_screen.dart';
import 'package:sign_ease/resetingpasswordscreens/forgotpassword.dart';
import 'package:sign_ease/utils/colors_utils.dart';
import 'package:sign_ease/resuable_widgets/reusable_widget.dart';
import 'package:sign_ease/utils/firebase_handler.dart';
import 'package:sign_ease/signlanguserscreen/signlanguser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Import for web storage
import 'dart:html' as html;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _rememberMe = false;

  final FirebaseHandler _firebaseHandler = FirebaseHandler();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    // Web: Use localStorage (works for both web and mobile in Flutter)
    setState(() {
      _emailTextController.text = html.window.localStorage['email'] ?? '';
      _passwordTextController.text = html.window.localStorage['password'] ?? '';
      _rememberMe = html.window.localStorage['rememberMe'] == 'true';
    });
  }

  Future<void> _saveCredentials() async {
    // Web: Use localStorage (works for both web and mobile in Flutter)
    if (_rememberMe) {
      html.window.localStorage['email'] = _emailTextController.text;
      html.window.localStorage['password'] = _passwordTextController.text;
      html.window.localStorage['rememberMe'] = _rememberMe.toString();
    } else {
      html.window.localStorage.remove('email');
      html.window.localStorage.remove('password');
      html.window.localStorage.remove('rememberMe');
    }
  }

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
              horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 20,
              vertical: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: logoWidget("assets/images/logo3.png"),
                ),
                const SizedBox(height: 20),
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
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: Color.fromARGB(255, 7, 130, 230),
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: Color.fromARGB(255, 7, 130, 230)),
                    ),
                  ],
                ),
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
        await _firebaseHandler.signIn(
          _emailTextController.text,
          _passwordTextController.text,
        );

        // Save credentials if remember me is checked
        await _saveCredentials();

        // Get current user data to determine user type
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final userData = await _firebaseHandler.getUserData(currentUser.uid);
          final userType = userData?['userType'] ?? 'Normal User';

          Navigator.pop(context);

          // Route based on user type
          if (userType == 'Sign Language User') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignLangUser(
                  userName: userData?['username'] ?? 'Unknown User',
                  userEmail: userData?['email'] ?? 'Unknown Email',
                  userId: currentUser.uid,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NormalUser()),
            );
          }
        }

        Fluttertoast.showToast(msg: "Sign in successful!");
      } catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please enter email and password");
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
                color: Color.fromARGB(255, 7, 130, 230),
                fontWeight: FontWeight.bold),
          ),
        )
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
      child: RichText(
        text: TextSpan(
          text: "Forgot Password?",
          style: TextStyle(
            color: Color.fromARGB(255, 7, 130, 230),
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: " (Mobile View)",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Open mobile view APK download
                  html.window.open(
                    'https://github.com/aliawan4027/signease/releases/download/sign-ease-mobile.apk',
                    '_blank',
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
