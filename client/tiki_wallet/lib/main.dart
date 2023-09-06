import 'package:flutter/material.dart';
import 'package:tiki_wallet/login_view.dart';
import 'package:tiki_wallet/services/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();

  runApp(const MaterialApp(
    title: 'Tiki Wallet',
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginView(),
    );
  }
}
