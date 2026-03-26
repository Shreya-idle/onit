import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDA9iRzszcZHdt2y0dZdE1vG5vQj_98wgI",
      authDomain: "onit-3c18c.firebaseapp.com",
      projectId: "onit-3c18c",
      storageBucket: "onit-3c18c.firebasestorage.app",
      messagingSenderId: "74835237689",
      appId: "1:74835237689:android:4bd44ccad9f025ada166e8", // Using the Android App ID from the json
      measurementId: "G-6EK49TBFYJ",
    ),
  );
  FirebaseAnalytics.instance.logAppOpen();
  runApp(const OnItApp());
}

class OnItApp extends StatelessWidget {
  const OnItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
