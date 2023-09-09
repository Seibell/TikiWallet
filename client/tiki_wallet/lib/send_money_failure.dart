import 'package:flutter/material.dart';

class SendMoneyFailureScreen extends StatelessWidget {
  final String senderPhoneNumber;
  final String receiverPhoneNumber;
  final double amountTransferred;

  const SendMoneyFailureScreen({
    Key? key,
    required this.senderPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountTransferred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Failed',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sender Phone Number: $senderPhoneNumber',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              'Receiver Phone Number: $receiverPhoneNumber',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              'Amount Intended to Transfer: \$${amountTransferred.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              'Reason: (you can display the failure reason here)',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.red,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
