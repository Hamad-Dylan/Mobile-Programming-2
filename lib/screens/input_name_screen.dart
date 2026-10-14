import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'menu_screen.dart';

class InputNameScreen extends StatefulWidget {
  final String tableNumber;

  const InputNameScreen({
    super.key,
    required this.tableNumber,
  });

  @override
  State<InputNameScreen> createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _proceedToMenu() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(
            tableNumber: widget.tableNumber,
            userName: _nameController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract table digits, e.g. "TABLE_01" -> "01" or "TABLE_05" -> "05"
    String displayTable = widget.tableNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (displayTable.isEmpty) {
      displayTable = widget.tableNumber;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative line art leaf outlines at the bottom
            Positioned(
              bottom: -20,
              left: -30,
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: LeafPainter(),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -20,
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: LeafPainter(),
                ),
              ),
            ),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to balance back button
                    ],
                  ),
                ),
                
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Meja Anda",
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Table pill container
                          Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                displayTable,
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 48,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 45),
                          Text(
                            "Masukkan Nama Anda",
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Name Input field
                          TextFormField(
                            controller: _nameController,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.secondary,
                              ),
                              hintText: "Contoh: Dylan",
                              hintStyle: AppTextStyles.body.copyWith(
                                color: AppColors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorStyle: const TextStyle(height: 0.8),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Nama tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 35),
                          // Lanjutkan button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _proceedToMenu,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Lanjutkan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Leaf Painter to draw elegant coffee leaf line art at the bottom of the screen
class LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    
    // Simple leaf path drawing
    path.moveTo(size.width * 0.1, size.height * 0.9);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.8,
      size.height * 0.2,
    );
    
    // Leaf 1 outline
    path.moveTo(size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.4,
      size.width * 0.4,
      size.height * 0.6,
    );

    // Leaf 2 outline
    path.moveTo(size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.8,
      size.width * 0.9,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.7,
    );
    
    // Veins
    path.moveTo(size.width * 0.42, size.height * 0.35);
    path.lineTo(size.width * 0.32, size.height * 0.28);
    path.moveTo(size.width * 0.46, size.height * 0.28);
    path.lineTo(size.width * 0.58, size.height * 0.22);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
