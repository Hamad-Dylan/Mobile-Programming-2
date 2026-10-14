import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'upload_receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String tableNumber;
  final String userName;
  final int totalPayment;
  final int subtotal;
  final int tax;

  const PaymentScreen({
    super.key,
    required this.tableNumber,
    required this.userName,
    required this.totalPayment,
    required this.subtotal,
    required this.tax,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;

  final List<Map<String, dynamic>> _ewallets = [
    {
      "id": "dana",
      "name": "DANA",
      "subtitle": "Bayar cepat dengan akun DANA Anda",
      "color": const Color(0xFF108EE9),
      "logoText": "DANA",
    },
    {
      "id": "gopay",
      "name": "GoPay",
      "subtitle": "Koneksi mudah dengan aplikasi Gojek",
      "color": const Color(0xFF00AED6),
      "logoText": "gopay",
    },
    {
      "id": "shopeepay",
      "name": "ShopeePay",
      "subtitle": "Diskon & cashback ShopeePay",
      "color": const Color(0xFFEE4D2D),
      "logoText": "S`Pay",
    },
    {
      "id": "ovo",
      "name": "OVO",
      "subtitle": "OVO Cash & OVO Points",
      "color": const Color(0xFF4C2A86),
      "logoText": "ovo",
    },
  ];

  final List<Map<String, dynamic>> _banks = [
    {
      "id": "bank",
      "name": "Transfer Bank (Virtual Account)",
      "subtitle": "Transfer manual via Mandiri, BCA, BRI, BNI",
      "color": AppColors.secondary,
      "logoText": "VA",
      "icon": Icons.account_balance_rounded,
    },
  ];

  String _formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  void _processPayment() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Silakan pilih metode pembayaran terlebih dahulu"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    String methodName = "";
    final allMethods = [..._ewallets, ..._banks];
    final selected = allMethods.firstWhere((m) => m["id"] == _selectedMethod);
    methodName = selected["name"];

    // Route to Upload Receipt Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadReceiptScreen(
          tableNumber: widget.tableNumber,
          userName: widget.userName,
          totalPayment: widget.totalPayment,
          paymentMethod: methodName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Metode Pembayaran",
          style: AppTextStyles.heading.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invoice Details Card (Rincian Tagihan) - Extremely Tidy
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Rincian Tagihan",
                                style: AppTextStyles.subHeading.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: AppColors.lightGrey, height: 20),
                          
                          // Invoice rows
                          _buildInvoiceDetailRow("Subtotal", _formatRupiah(widget.subtotal)),
                          const SizedBox(height: 8),
                          _buildInvoiceDetailRow("Pajak [10%]", _formatRupiah(widget.tax)),
                          
                          const Divider(color: AppColors.lightGrey, height: 24),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Tagihan",
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _formatRupiah(widget.totalPayment),
                                style: AppTextStyles.price.copyWith(
                                  fontSize: 18,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Dompet Digital Section Header
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Dompet Digital (E-Wallet)",
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    // E-Wallets List
                    ..._ewallets.map((wallet) => _buildPaymentTile(wallet, isEwallet: true)),

                    const SizedBox(height: 16),

                    // Bank Transfer Section Header
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Transfer Bank",
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    // Banks List
                    ..._banks.map((bank) => _buildPaymentTile(bank, isEwallet: false)),

                    const SizedBox(height: 24),

                    // Security Footer info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Semua transaksi Anda dienkripsi secara aman.",
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Pay Button Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _processPayment,
                  icon: const Icon(
                    Icons.security_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Bayar Sekarang",
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
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildInvoiceDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.secondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(Map<String, dynamic> method, {required bool isEwallet}) {
    final isSelected = _selectedMethod == method["id"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method["id"];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.lightGrey,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Premium Logo Badge
              Container(
                width: 50,
                height: 34,
                decoration: BoxDecoration(
                  color: isEwallet ? method["color"] : method["color"].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isEwallet
                      ? Text(
                          method["logoText"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        )
                      : Icon(
                          method["icon"],
                          color: method["color"],
                          size: 20,
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Method description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method["name"],
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      method["subtitle"],
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Circle
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
