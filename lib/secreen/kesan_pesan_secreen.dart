import 'package:flutter/material.dart';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;
const cardBackgroundColor = Color.fromARGB(255, 147, 240, 226); 

class KesanPesanScreen extends StatefulWidget {
  const KesanPesanScreen({super.key});

  @override
  State<KesanPesanScreen> createState() => _KesanPesanScreenState();
}

class _KesanPesanScreenState extends State<KesanPesanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kesan dan Pesan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: accessoriesColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: cardBackgroundColor, // Set the background color of the card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kesan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Terima kasih banyak atas ilmu yang telah bapak sampaikan, pembelajarannya sangat terstruktur. Namun, kendalanya ada di diri saya yang belum bisa explore sendiri. Sebenarnya belajar pemrograman mobile itu sangat berguna, salah satunya ketika kita ingin membuat aplikasi yang kita inginkan dan butuhkan. Mohon maaf, hanya bisa membuat aplikasi yang masih sederhana',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: cardBackgroundColor, // Set the background color of the card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Semoga sehat selalu dan pembelajaran kedepannya bisa lebih baik lagi',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
