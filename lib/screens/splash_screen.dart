import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  // Gold Coffee Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.coffee_outlined,
                      color: AppColors.accent,
                      size: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Text Logo
                  Text(
                    "COFFEE",
                    style: AppTextStyles.splashTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ORDERING APP",
                    style: AppTextStyles.splashTitle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent.withOpacity(0.85),
                      letterSpacing: 4,
                    ),
                  ),
                  const Spacer(flex: 3),
                  // Progress Loading Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressController.value,
                                backgroundColor: AppColors.primary.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                minHeight: 4,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Loading...",
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.accent.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}