import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyClr-9tEK8Dl8Ofu8NRv0bsNtrcUYCFMuo",
          authDomain: "sign-ease-8dcfe.firebaseapp.com",
          projectId: "sign-ease-8dcfe",
          storageBucket: "sign-ease-8dcfe.appspot.com",
          messagingSenderId: "919722991183",
          appId: "1:919722991183:web:3ace9c5a0914cc6ae1143a",
          measurementId: "G-VRE8VJN0RZ"),
    );
    print('✅ Firebase initialized successfully for web');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sign Ease',
            theme: ThemeData(
              primaryColor: themeProvider.primaryColor,
              brightness: Brightness.light,
              scaffoldBackgroundColor: themeProvider.containerColor,
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: themeProvider.textColor),
                bodyMedium: TextStyle(color: themeProvider.textColor),
                bodySmall: TextStyle(color: themeProvider.textColor),
                titleLarge: TextStyle(color: themeProvider.textColor),
                titleMedium: TextStyle(color: themeProvider.textColor),
                titleSmall: TextStyle(color: themeProvider.textColor),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Image.asset(
          'assets/logo2.jpg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
