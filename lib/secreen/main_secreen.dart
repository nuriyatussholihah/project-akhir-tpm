import 'package:flutter/material.dart';
import 'package:project_tpm/secreen/favorites_secreen.dart';
import 'package:project_tpm/secreen/list_chara_secreen.dart';
import 'package:project_tpm/secreen/profile_secreen.dart';
import 'package:project_tpm/secreen/synopsis_secreen.dart';
import 'package:project_tpm/secreen/kesan_pesan_secreen.dart';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    FavoritesScreen(),
    KesanPesanScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: accessoriesColor,
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'Kesan Pesan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: accessoriesColor,
          title: Text(
            "Rick & Morty",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 228, 231, 228),
                    width: 1.0, // Adjust the height of the top border
                  ),
                ),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: const Color.fromARGB(255, 7, 7, 7),
                unselectedLabelColor: const Color.fromARGB(255, 200, 200, 200),
                tabs: [
                  Tab(text: 'Sinopsis'),
                  Tab(text: 'Characters'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Sinopsis(),
            ListChara(),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
