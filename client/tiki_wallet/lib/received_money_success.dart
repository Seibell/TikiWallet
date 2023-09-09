import 'package:flutter/material.dart';

class ReceivedMoneySuccessScreen extends StatelessWidget {
  final String senderPhoneNumber;
  final String receiverPhoneNumber;
  final double amountReceived;

  const ReceivedMoneySuccessScreen({
    Key? key,
    required this.senderPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountReceived,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Received',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
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
              'Amount Received: \$${amountReceived.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
