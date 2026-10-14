import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'order_success_screen.dart';

class UploadReceiptScreen extends StatefulWidget {
  final String tableNumber;
  final String userName;
  final int totalPayment;
  final String paymentMethod;

  const UploadReceiptScreen({
    super.key,
    required this.tableNumber,
    required this.userName,
    required this.totalPayment,
    required this.paymentMethod,
  });

  @override
  State<UploadReceiptScreen> createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  bool _isReceiptUploaded = false;
  bool _isLoading = false;

  String _formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Unggah Bukti Bayar",
                  style: AppTextStyles.subHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  ),
                  title: Text(
                    "Ambil Foto via Kamera",
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                  ),
                  subtitle: Text(
                    "Gunakan kamera untuk mengambil foto struk fisik",
                    style: AppTextStyles.subtitle.copyWith(fontSize: 11),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateUpload("kamera");
                  },
                ),
                const Divider(color: AppColors.lightGrey),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  ),
                  title: Text(
                    "Pilih dari Galeri",
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                  ),
                  subtitle: Text(
                    "Pilih screenshot bukti transfer dari galeri Anda",
                    style: AppTextStyles.subtitle.copyWith(fontSize: 11),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _simulateUpload("galeri");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulateUpload(String source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil mengunggah bukti dari $source!"),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    setState(() {
      _isReceiptUploaded = true;
    });
  }

  void _deleteReceipt() {
    setState(() {
      _isReceiptUploaded = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Bukti transfer dihapus."),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _confirmAndSubmit() {
    setState(() {
      _isLoading = true;
    });

    // Simulate 1.5 seconds latency for server upload
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to Success Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(
              tableNumber: widget.tableNumber,
              userName: widget.userName,
              totalPayment: widget.totalPayment,
              paymentMethod: widget.paymentMethod,
            ),
          ),
        );
      }
    });
  }

  bool _isEWallet() {
    final methodLower = widget.paymentMethod.toLowerCase();
    return methodLower.contains("dana") ||
        methodLower.contains("gopay") ||
        methodLower.contains("ovo") ||
        methodLower.contains("shopeepay") ||
        methodLower.contains("pay");
  }

  @override
  Widget build(BuildContext context) {
    final isEwallet = _isEWallet();

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
          "Unggah Bukti Bayar",
          style: AppTextStyles.heading.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rincian Pembayaran Card
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Pembayaran",
                                      style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatRupiah(widget.totalPayment),
                                      style: AppTextStyles.price.copyWith(
                                        fontSize: 22,
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.payment_rounded,
                                        color: AppColors.primary,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        widget.paymentMethod,
                                        style: AppTextStyles.bodyBold.copyWith(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Petunjuk Bayar Card
                      Text(
                        "Petunjuk Pembayaran",
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

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
                        child: isEwallet
                            ? _buildEWalletInstructions()
                            : _buildBankInstructions(),
                      ),

                      const SizedBox(height: 24),

                      // Upload Area Card
                      Text(
                        "Unggah Struk Bukti Bayar",
                        style: AppTextStyles.subHeading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      InkWell(
                        onTap: _isReceiptUploaded ? null : _showImagePicker,
                        borderRadius: BorderRadius.circular(16),
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: _isReceiptUploaded ? AppColors.accent : AppColors.grey,
                            strokeWidth: 2,
                            gap: 6,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: _isReceiptUploaded
                                ? _buildReceiptUploadedPreview()
                                : _buildReceiptEmptyState(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Confirmation CTA Card
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
                  child: ElevatedButton(
                    onPressed: _isReceiptUploaded ? _confirmAndSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Konfirmasi & Kirim",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isReceiptUploaded ? Colors.white : Colors.white60,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading Screen Overlaid
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Mengunggah struk...",
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Mohon tunggu sebentar",
                        style: AppTextStyles.subtitle.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEWalletInstructions() {
    return Column(
      children: [
        Text(
          "Scan QRIS di bawah ini menggunakan aplikasi dompet digital Anda, selesaikan transaksi, lalu screenshot bukti transfernya.",
          style: AppTextStyles.body.copyWith(fontSize: 12, height: 1.4),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Mock QRIS Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(
            children: [
              // Mock QRIS Header Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "QRIS",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF00377E),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 14,
                    color: const Color(0xFFEE4D2D),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "GPN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFFE41E26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Simulated QR code grid pattern
              Container(
                width: 140,
                height: 140,
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: CustomPaint(
                  painter: MockQRCodePainter(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "KOPI KITA CAFE",
                style: AppTextStyles.bodyBold.copyWith(fontSize: 12, color: AppColors.primary),
              ),
              Text(
                "NMID: ID1029384756",
                style: AppTextStyles.subtitle.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankInstructions() {
    const vaNumber = "8830 0812 3456 7890";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Silakan transfer tepat sesuai total nominal ke nomor Virtual Account di bawah ini:",
          style: AppTextStyles.body.copyWith(fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nomor Virtual Account",
                    style: AppTextStyles.subtitle.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vaNumber,
                    style: AppTextStyles.bodyBold.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.5,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: "8830081234567890"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Nomor Virtual Account berhasil disalin!"),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, color: AppColors.accent, size: 20),
                tooltip: "Salin VA",
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, size: 14, color: AppColors.secondary),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                "Pembayaran Anda akan diverifikasi setelah bukti transfer diunggah di bawah.",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.secondary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceiptEmptyState() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: AppColors.grey,
          size: 44,
        ),
        SizedBox(height: 12),
        Text(
          "Pilih atau Foto Bukti Transfer",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Format file: JPG, PNG (maks. 5MB)",
          style: TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptUploadedPreview() {
    return Stack(
      children: [
        // Simulated Receipt graphic using widgets
        Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50]?.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "TRANSFER BERHASIL",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRupiah(widget.totalPayment),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Divider(color: Colors.black12, height: 10),
                _buildReceiptPreviewRow("Penerima", "KOPI KITA CAFE"),
                _buildReceiptPreviewRow("Tanggal", "23 Jun 2026, 21:30 WIB"),
                _buildReceiptPreviewRow("Ref ID", "TRX-8294720938"),
              ],
            ),
          ),
        ),
        // Remove button at top right
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: _deleteReceipt,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw a dashed border around a rounded rectangle
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final double length = gap;
        final double nextDistance = distance + length;
        if (draw) {
          canvas.drawPath(
            pathMetric.extractPath(distance, nextDistance),
            paint,
          );
        }
        distance = nextDistance;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}

// Painter to draw a simulated QR code grid structure
class MockQRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Outer markers
    _drawMarker(canvas, 0, 0, 40, paint);
    _drawMarker(canvas, size.width - 40, 0, 40, paint);
    _drawMarker(canvas, 0, size.height - 40, 40, paint);

    // Random mock pixels
    final double pixelSize = size.width / 15;
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        // Skip marker areas
        if ((i < 5 && j < 5) || (i > 9 && j < 5) || (i < 5 && j > 9)) {
          continue;
        }
        // Randomly draw a block to look like a QR code
        if ((i * j + i + j) % 3 == 0 || (i + j) % 5 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i * pixelSize, j * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  void _drawMarker(Canvas canvas, double x, double y, double size, Paint paint) {
    // Outer square
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), paint);
    
    // Middle white gap
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + 5, y + 5, size - 10, size - 10), paint);
    
    // Inner square
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(x + 10, y + 10, size - 20, size - 20), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
