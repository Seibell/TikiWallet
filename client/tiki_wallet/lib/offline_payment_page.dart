import 'package:flutter/material.dart';
import 'package:tiki_wallet/receive_money_page.dart';
import 'wifi_direct_transaction_page.dart';
import 'transaction.dart';

class OfflinePaymentPage extends StatelessWidget {
  final double accountBalance;
  final String senderPhoneNumber; // taken from current_account

  OfflinePaymentPage(
      {super.key,
      required this.accountBalance,
      required this.senderPhoneNumber});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Payment'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Receiver Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              Text(
                'Current Balance: \$${accountBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    Transaction transaction = Transaction(
                      senderPhoneNumber: int.parse(senderPhoneNumber),
                      receiverPhoneNumber: int.parse(_phoneController.text),
                      amount: double.parse(_amountController.text),
                      timestamp: DateTime.now(),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WifiDirectPage(transaction: transaction)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text('Send'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceiveMoneyOfflinePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Receive')),
            ],
          ),
        ),
      ),
    );
  }
}
