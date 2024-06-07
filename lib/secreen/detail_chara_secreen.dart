import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;

class DetailChara extends StatefulWidget {
  final Map<String, dynamic> character;

  DetailChara({Key? key, required this.character}) : super(key: key);

  @override
  State<DetailChara> createState() => _DetailCharaState();
}

class _DetailCharaState extends State<DetailChara> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_characters') ?? [];
    setState(() {
      _isFavorite = favoriteList.contains(json.encode(widget.character));
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_characters') ?? [];
    final characterString = json.encode(widget.character);

    if (_isFavorite) {
      favoriteList.remove(characterString);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil menghapus dari favorit'),
        ),
      );
    } else {
      favoriteList.add(characterString);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil menambahkan ke favorit'),
        ),
      );
    }

    await prefs.setStringList('favorite_characters', favoriteList);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Karakter",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: accessoriesColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _buildCharaDetail(),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildCharaDetail() {
    final character = widget.character;
    return Center(
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: accessoriesColor,
                    ),
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image.network(character['image']),
                    ),
                  ),
                ],
              ),
            ),
            _buildDetailCard(character),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> character) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama: ${character['name']}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Status: ${character['status']}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Spesies: ${character['species']}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Gender: ${character['gender']}",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
