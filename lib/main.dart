import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_ease/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_ease/screens/signin_screen.dart';
import 'package:sign_ease/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: FirebaseConfig.apiKey,
      authDomain: FirebaseConfig.authDomain,
      projectId: FirebaseConfig.projectId,
      storageBucket: FirebaseConfig.storageBucket,
      messagingSenderId: FirebaseConfig.messagingSenderId,
      appId: FirebaseConfig.appId,
      measurementId: FirebaseConfig.measurementId,
    ),
  );
  print('✅ Firebase initialized successfully for web');
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
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: themeProvider.primaryColor,
              scaffoldBackgroundColor: themeProvider.containerColor,
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: themeProvider.textColor),
                bodyMedium: TextStyle(color: themeProvider.textColor),
                bodySmall: TextStyle(color: themeProvider.textColor),
                headlineLarge: TextStyle(color: themeProvider.textColor),
                headlineMedium: TextStyle(color: themeProvider.textColor),
                headlineSmall: TextStyle(color: themeProvider.textColor),
                titleLarge: TextStyle(color: themeProvider.textColor),
                titleMedium: TextStyle(color: themeProvider.textColor),
                titleSmall: TextStyle(color: themeProvider.textColor),
                labelLarge: TextStyle(color: themeProvider.textColor),
                labelMedium: TextStyle(color: themeProvider.textColor),
                labelSmall: TextStyle(color: themeProvider.textColor),
                displayLarge: TextStyle(color: themeProvider.textColor),
                displayMedium: TextStyle(color: themeProvider.textColor),
                displaySmall: TextStyle(color: themeProvider.textColor),
              ),
            ),
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
