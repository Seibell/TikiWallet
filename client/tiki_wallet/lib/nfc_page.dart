import 'package:flutter/material.dart';
import 'transaction.dart';
import 'nfc_handler.dart';
import 'dart:async';
import 'offline_payment_page.dart';

class NFCPage extends StatefulWidget {
  final Transaction transaction;

  NFCPage({required this.transaction});

  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  bool _nfcActive = false;
  bool _transactionInProgress = false;
  String _transactionStatus = "detecting";
  final NfcHandler _nfcHandler = NfcHandler();
  late ValueNotifier<int> _timerNotifier;
  late Timer _timer;
  int _currentTime = 10;

  @override
  void initState() {
    super.initState();
    _startNfcTransaction();
    _startTimer();
  }

  void _navigateToOfflinePaymentPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OfflinePaymentPage(
          accountBalance: 200.75, //temp value
          senderPhoneNumber: "12345678",
        ),
      ),
    );
  }

  void _startTimer() {
    _timerNotifier = ValueNotifier<int>(_currentTime);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_currentTime > 0) {
        _timerNotifier.value = --_currentTime;
      } else {
        timer.cancel();
        if (_transactionInProgress && _transactionStatus != "approved") {
          _transactionStatus = "failed";
          print("Transaction Failed");
          _showTransactionFailedDialog(context);
        }
      }
    });
  }

  Future<void> _startNfcTransaction() async {
    try {
      _transactionInProgress = true;
      await _nfcHandler.writeTransactionToNfc(widget.transaction);
      setState(() {
        _nfcActive = true;
        _transactionStatus = "searching";
      });
      _searchForOtherDevice();
    } catch (e) {
      setState(() {
        _nfcActive = false;
        _transactionInProgress = false;
      });
      _showTransactionFailedDialog(context);
    }
  }

  /*
  This method is broken, after 5 seconds will always show transaction failed
  */
  Future<void> _searchForOtherDevice() async {
    try {
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        _transactionStatus = "device found"; // Device found
      });
      _checkNfcTransaction();
    } catch (e) {
      print("******** ERROR: $e");
      _showTransactionFailedDialog(context);
    }
  }

  Future<void> _checkNfcTransaction() async {
    try {
      String responseStatus = await _nfcHandler.readTransactionFromNfc();
      if (responseStatus == "APPROVED") {
        _transactionInProgress = false;
        _transactionStatus = "approved";
        _timer.cancel();
        _showTransactionSuccessDialog(context);
      } else {
        _showTransactionFailedDialog(context);
      }
    } catch (e) {
      _showTransactionFailedDialog(context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
            SizedBox(height: 32.0),
            ValueListenableBuilder<int>(
              valueListenable: _timerNotifier,
              builder: (context, value, child) {
                return Center(
                  child: Container(
                    width: 200.0,
                    height: 10.0,
                    child: LinearProgressIndicator(
                      value: value / 10,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            if (_transactionStatus == "detecting")
              Text(
                'Detecting other NFC devices...',
                style: TextStyle(fontSize: 24.0),
              )
            else if (_transactionStatus == "searching")
              Text(
                'Searching for other devices...',
                style: TextStyle(fontSize: 24.0, color: Colors.blue),
              )
            else if (_transactionStatus == "device found")
              Text(
                'Device Found',
                style: TextStyle(fontSize: 24.0, color: Colors.green),
              )
            else if (_transactionStatus == "approved")
              Text(
                'Transaction Successful',
                style: TextStyle(fontSize: 24.0, color: Colors.green),
              )
            else if (_transactionStatus == "failed")
              Text(
                'Transaction Failed',
                style: TextStyle(fontSize: 24.0, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // Show Transaction Successful Dialog
  Future<void> _showTransactionSuccessDialog(BuildContext context) async {
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
            'Transaction Successful',
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
                _navigateToOfflinePaymentPage();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
