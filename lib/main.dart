import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_tpm/secreen/login_secreen.dart';
import 'package:project_tpm/model_hive/datauser_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initiateLocalDB();
  await _initializeNotifications();
  runApp(const MyApp());
}

Future<void> initiateLocalDB() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataUserModelAdapter());
  await Hive.openBox<DataUserModel>('data_user');
  await Hive.openBox<String>('session_box');
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ricky & Morty App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
