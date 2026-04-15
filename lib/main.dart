import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
      ),
      home: const UlasanProdukScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UlasanProdukScreen extends StatefulWidget {
  const UlasanProdukScreen({super.key});

  @override
  State<UlasanProdukScreen> createState() => _UlasanProdukScreenState();
}

class _UlasanProdukScreenState extends State<UlasanProdukScreen> {
  double _ratingUtama = 0.0;
  double _ratingKualitas = 0.0;
  double _ratingWaktu = 0.0;

  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitUlasan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Ulasan ${_ratingUtama.toStringAsFixed(1)} bintang berhasil dikirim!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai Produk',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductCard(),
              const SizedBox(height: 24),
              _buildMainRatingSection(),
              const Divider(height: 40, thickness: 1),
              _buildSubRatingSection(),
              const SizedBox(height: 24),
              _buildRatingReadOnlySection(),
              const SizedBox(height: 24),
              _buildReviewTextField(),
              const SizedBox(height: 24),
              _buildPhotoUploadSection(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.view_in_ar_rounded,
                size: 35, color: Colors.pinkAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Custom 3D Souvenir - Wedding',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text('Uni Gift Studio',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 6),

                // API #2 — RatingBarIndicator (statis, tidak bisa diklik)
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 4.8,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 14.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 4),
                    const Text('(1.2k terjual)',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Bagaimana kualitas produk ini?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // API #1 — RatingBar.builder
        // API #3 — allowHalfRating
        // API #4 — updateOnDrag
        // API #7 — glowColor
        // API #8 — unratedColor
        // API #9 — onRatingUpdate
        // API #10 — itemPadding
        Center(
          child: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,                        // API #3
            updateOnDrag: true,                           // API #4
            itemCount: 5,
            itemSize: 50.0,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0), // API #10
            unratedColor: Colors.grey.shade300,           // API #8
            glowColor: Colors.pinkAccent.withOpacity(0.4), // API #7
            itemBuilder: (context, _) =>
                const Icon(Icons.star_rounded, color: Colors.amber),
            onRatingUpdate: (rating) {                    // API #9
              setState(() => _ratingUtama = rating);
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _getRatingDescription(_ratingUtama),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _ratingUtama > 0 ? Colors.pinkAccent : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Beri nilai detail produk (Opsional)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 16),
        _buildSubRatingRow(
          'Detail & Presisi 3D',
          (rating) => setState(() => _ratingKualitas = rating),
        ),
        const SizedBox(height: 12),
        _buildSubRatingRow(
          'Kecepatan Pengerjaan',
          (rating) => setState(() => _ratingWaktu = rating),
        ),
      ],
    );
  }

  Widget _buildSubRatingRow(String title, ValueChanged<double> onUpdate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade700)),

        // API #1 — RatingBar.builder
        // API #3 — allowHalfRating
        // API #5 — tapOnlyMode: false (bisa di-drag)
        // API #8 — unratedColor
        // API #9 — onRatingUpdate
        // API #10 — itemPadding
        RatingBar.builder(
          initialRating: 0,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,                          // API #3
          tapOnlyMode: false,                             // API #5
          itemCount: 5,
          itemSize: 24.0,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0), // API #10
          unratedColor: Colors.grey.shade300,             // API #8
          itemBuilder: (context, _) =>
              const Icon(Icons.star_rounded, color: Colors.orangeAccent),
          onRatingUpdate: onUpdate,                       // API #9
        ),
      ],
    );
  }

  Widget _buildRatingReadOnlySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 16),
              const SizedBox(width: 6),
              Text(
                'Rating rata-rata dari pembeli lain',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // API #1 — RatingBar.builder
              // API #3 — allowHalfRating
              // API #6 — ignoreGestures (read-only)
              // API #8 — unratedColor
              // API #9 — onRatingUpdate
              RatingBar.builder(
                initialRating: 4.3,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,                    // API #3
                ignoreGestures: true,                     // API #6
                itemCount: 5,
                itemSize: 22.0,
                unratedColor: Colors.grey.shade300,       // API #8
                itemBuilder: (context, _) =>
                    const Icon(Icons.star_rounded, color: Colors.amber),
                onRatingUpdate: (_) {},                   // API #9
              ),
              const SizedBox(width: 8),
              Text(
                '4.3 dari 5 (287 ulasan)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildRatingRow('Kualitas Bahan', 4.5),
          const SizedBox(height: 6),
          _buildRatingRow('Akurasi Desain', 4.7),
          const SizedBox(height: 6),
          _buildRatingRow('Kerapian Packaging', 3.9),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, double value) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ),
        // API #2 — RatingBarIndicator
        RatingBarIndicator(
          rating: value,
          itemBuilder: (context, _) =>
              const Icon(Icons.star_rounded, color: Colors.amber),
          itemCount: 5,
          itemSize: 14.0,
          direction: Axis.horizontal,
        ),
        const SizedBox(width: 6),
        Text(value.toStringAsFixed(1),
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildReviewTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tulis pengalamanmu',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 10),
        TextField(
          controller: _reviewController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
                'Misal: Kualitas printing 3D-nya sangat halus dan mirip dengan desain...',
            hintStyle:
                TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.pinkAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lampirkan Foto/Video (Opsional)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPhotoBox(icon: Icons.camera_alt_outlined, label: 'Kamera'),
            const SizedBox(width: 12),
            _buildPhotoBox(icon: Icons.photo_library_outlined, label: 'Galeri'),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoBox({required IconData icon, required String label}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: (_ratingUtama == 0 || _isLoading) ? null : _submitUlasan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Text('Kirim Ulasan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _getRatingDescription(double rating) {
    if (rating == 0) return 'Geser untuk menilai';
    if (rating <= 1.5) return 'Sangat Buruk 😞';
    if (rating <= 2.5) return 'Kurang Baik 😕';
    if (rating <= 3.5) return 'Cukup Baik 😐';
    if (rating <= 4.5) return 'Sangat Bagus! 😊';
    return 'Luar Biasa Sempurna! 😍';
  }
}