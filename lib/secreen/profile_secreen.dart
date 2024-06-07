import 'package:flutter/material.dart';
import 'package:project_tpm/hive/hive_database.dart';
import 'package:project_tpm/secreen/login_secreen.dart';
import 'package:project_tpm/secreen/main_secreen.dart';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;
const newbackgroundColor = Colors.red;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1;
  late String _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final currentUser = HiveDatabase.getCurrentUser();
    setState(() {
      _currentUser = currentUser ?? 'User';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()),
      );
    }
  }

  void _logout() {
    HiveDatabase.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    );

    final snackBar = SnackBar(
      content: Text(
        "You're logging out.",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showDatabase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data User'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: HiveDatabase.getLength(),
              itemBuilder: (context, index) {
                final user = HiveDatabase.getUserAt(index);
                if (user != null) {
                  return ListTile(
                    title: Text("Username: ${user.username}"),
                    subtitle: Text("Password (hashed): ${user.password}"),
                  );
                } else {
                  return ListTile(
                    title: Text('Unknown User'),
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accessoriesColor,
        title: Text(
          "Profil",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
                backgroundImage: AssetImage('assets/image-1.png'),  
              ),
            SizedBox(height: 20),
            Text(
              "Halo $_currentUser, Selamat Datang!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showDatabase,
                  child: const Text(
                    "Data",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: accessoriesColor,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _logout();
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: newbackgroundColor,
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
