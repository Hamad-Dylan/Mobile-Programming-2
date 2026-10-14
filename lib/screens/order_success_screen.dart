import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/cart_service.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String tableNumber;
  final String userName;
  final int totalPayment;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.tableNumber,
    required this.userName,
    required this.totalPayment,
    required this.paymentMethod,
  });

  // Generates a mock order number in the format #ORD-YYMMDD-XXX
  String _generateOrderNumber() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    
    final random = Random();
    final randomNum = random.nextInt(900) + 100; // 100 to 999
    
    return "#ORD-$year$month$day-$randomNum";
  }

  String _formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    // Extract table digits, e.g. "TABLE_01" -> "01"
    String displayTable = tableNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (displayTable.isEmpty) {
      displayTable = tableNumber;
    }

    final orderNumber = _generateOrderNumber();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                  
                  // Light Brown Checkmark Badge
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                      size: 60,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Text(
                    "Pesanan Berhasil!",
                    style: AppTextStyles.title.copyWith(
                      fontSize: 26,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Terima kasih, pesanan Anda sedang kami siapkan.",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary.withOpacity(0.85),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // White Receipt Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Receipt Info
                        _buildReceiptRow("No. Pesanan", orderNumber),
                        const SizedBox(height: 8),
                        _buildReceiptRow("Nama", userName),
                        const SizedBox(height: 8),
                        _buildReceiptRow("Meja", displayTable),
                        const SizedBox(height: 8),
                        _buildReceiptRow("Metode Bayar", paymentMethod),
                        
                        const Divider(color: AppColors.lightGrey, height: 26, thickness: 1),
                        
                        // Title for Items list
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Rincian Pesanan",
                            style: AppTextStyles.subHeading.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // List of Ordered Items
                        ...CartService.getItems().map((item) {
                          final itemTotal = item.menuItem.price * item.quantity;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.quantity}x  ${item.menuItem.name}",
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    Text(
                                      _formatRupiah(itemTotal),
                                      style: AppTextStyles.bodyBold.copyWith(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.notes.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Text(
                                      "Catatan: ${item.notes}",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.secondary.withOpacity(0.75),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        
                        const Divider(color: AppColors.lightGrey, height: 26, thickness: 1),
                        
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Pembayaran",
                              style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _formatRupiah(totalPayment),
                              style: AppTextStyles.price.copyWith(
                                fontSize: 15,
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Lihat Menu Lagi Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CartService.clearCart();
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Lihat Menu Lagi",
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
                        elevation: 2,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.primary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 15 : 14,
          ),
        ),
      ],
    );
  }
}