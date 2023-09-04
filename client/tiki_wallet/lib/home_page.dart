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
            title: Text('Tiki Wallet'),
          ),
          body: Center(
            child: Text(
              'placeholder for home dashboard page',
            ),
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
