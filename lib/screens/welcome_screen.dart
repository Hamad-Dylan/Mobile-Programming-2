import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'qr_scan_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Dark Brown Coffee Logo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee,
                          color: AppColors.primary,
                          size: 55,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "COFFEE",
                        style: AppTextStyles.title.copyWith(
                          fontSize: 24,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        "ORDERING APP",
                        style: AppTextStyles.title.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Greetings
                      Text(
                        "Selamat Datang!",
                        style: AppTextStyles.title.copyWith(
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Scan QR Code pada meja untuk mulai memesan",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.secondary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 35),
                      // Scan QR Code Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRScanScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Scan QR Code",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Cafe Illustration
            SizedBox(
              width: double.infinity,
              height: 230,
              child: Image.asset(
                'assets/images/welcome_illustration.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}