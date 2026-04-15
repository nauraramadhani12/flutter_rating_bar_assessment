import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF9FA), // Warna background pastel minimalis
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
  // Variabel penampung nilai rating
  double _nilaiRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar/Ikon Produk Suvenir
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: const Icon(Icons.card_giftcard_rounded, size: 80, color: Colors.pinkAccent),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Suvenir 3D Custom',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bagaimana kualitas pesanan Anda?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Memanggil Widget RatingBar.builder beserta 11 API lainnya
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 45.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                unratedColor: Colors.grey[300],
                glowColor: Colors.pinkAccent.withOpacity(0.5),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _nilaiRating = rating;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Menampilkan angka rating yang dipilih secara dinamis
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _nilaiRating > 0 ? 'Rating Anda: $_nilaiRating / 5.0' : 'Geser bintang untuk menilai',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: _nilaiRating > 0 ? Colors.pinkAccent : Colors.grey,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Tombol Kirim
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // Tombol hanya aktif jika rating lebih dari 0
                  onPressed: _nilaiRating == 0 
                      ? null 
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Terima kasih! Ulasan $_nilaiRating bintang berhasil dikirim.'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Kirim Ulasan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}