import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CoffeeOrderingApp());
}

class CoffeeOrderingApp extends StatelessWidget {
  const CoffeeOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Ordering',

      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColors.primary,
      ),

      home: const SplashScreen(),
    );
  }
}
