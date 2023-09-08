import 'package:flutter/material.dart';
import 'package:tiki_wallet/login_view.dart';
import 'package:tiki_wallet/services/user_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  Stripe.publishableKey =
      "pk_test_51NnNSQF9kWEXuhtShDqIe93QtBvRllXLIB2YIodOT2iaGyKt6dbpJWpa7BIA6rJSDEHT4PuZsW9BLjTwoCJgf5Cn00wcA9lDre";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

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
