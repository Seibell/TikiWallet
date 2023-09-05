import 'package:tiki_wallet/login_view.dart';
import 'package:tiki_wallet/nfc_page.dart';
import 'package:tiki_wallet/top_up_page.dart';

import 'bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text('Tiki Wallet'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    // Change LOGGED_IN in db to false
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
              ),
            ],
          ),
          body: _currentIndex == 0
              ? Center(child: TopUpPage())
              : Center(
                  child: NFCPage(),
                ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: Container(
            width: 70,
            height: 70,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.brown,
                onPressed: () {
                  // payment feature
                },
                tooltip: 'Pay',
                child: const Icon(Icons.attach_money),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
