import 'package:flutter/material.dart';

class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  bool _nfcActive = false;

  // Add NFC event handling logic here, if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.nfc,
              size: 96.0,
              color: _nfcActive ? Colors.green : Colors.grey,
            ),
            SizedBox(height: 16.0),
            if (_nfcActive)
              Column(
                children: <Widget>[
                  Text(
                    'NFC Detected!',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 16.0),
                  CircularProgressIndicator(),
                ],
              )
            else
              Container(
                width: 250.0, // Set the fixed width
                child: Text(
                  'Tap your phone on another device or terminal to initiate NFC',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _showTransactionFailedDialog(context);
              },
              child: Text('Show Transaction Failed Dialog'),
            )
          ],
        ),
      ),
    );
  }

  // Show Transaction Unsuccessful Dialog
  Future<void> _showTransactionFailedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Icon(
              Icons.warning,
              size: 80.0,
              color: Colors.orange,
            ),
          ),
          content: Text(
            'Transaction Unsuccessful',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
