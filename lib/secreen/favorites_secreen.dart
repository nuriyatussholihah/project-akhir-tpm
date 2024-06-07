import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const accessoriesColor = Colors.teal;
const backgroundColor = Colors.white;

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favorites = [];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'favorite_channel', // channelId
      'Favorite Characters', // channelName
      channelDescription: 'Notification for Favorite Characters', // Use named parameter for description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Favorite Characters',
      'You have no favorite characters yet! Add some to your favorites.',
      platformChannelSpecifics,
      payload: 'Favorite Notification',
    );
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? favoriteStrings = prefs.getStringList('favorite_characters') ?? [];
      _favorites = favoriteStrings.map((item) {
        return Map<String, dynamic>.from(json.decode(item));
      }).toList();

      if (_favorites.isEmpty) {
        _showNotification();
      }
    });
  }

  void _removeFavorite(Map<String, dynamic> character) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteStrings = prefs.getStringList('favorite_characters') ?? [];
    favoriteStrings.remove(json.encode(character));
    await prefs.setStringList('favorite_characters', favoriteStrings);
    setState(() {
      _favorites.remove(character);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Characters",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: accessoriesColor,
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: _favorites.isEmpty
            ? Center(
                child: Text(
                  "No favorites yet",
                  style: TextStyle(color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> character = _favorites[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Image.network(character['image']),
                        title: Text(character['name'], style: TextStyle(color: Colors.black)),
                        subtitle: Text("${character['species']} - ${character['status']}", style: TextStyle(color: Colors.black)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFavorite(character),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    flutterLocalNotificationsPlugin.cancelAll();
    super.dispose();
  }
}
