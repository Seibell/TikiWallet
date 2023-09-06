import 'package:flutter/material.dart';
import 'nfc_handler.dart';
import 'transaction.dart';
import 'nfc_page.dart';

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
  final NfcHandler _nfcHandler = NfcHandler();

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
                    // Creates transaction object with approved: False to be sent to NFC
                    Transaction transaction = Transaction(
                      type: 'Payment',
                      senderPhoneNumber: senderPhoneNumber,
                      receiverPhoneNumber: _phoneController.text,
                      transactionType: 'Offline Payment',
                      amount: double.parse(_amountController.text),
                      timestamp: DateTime.now(),
                      approved: false,
                    );

                    // Writes the Transaction to the NFC card
                    try {
                      await _nfcHandler.writeTransactionToNfc(transaction);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Data written to NFC successfully')));

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              NFCPage(transaction: transaction)));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error writing data to NFC: $e')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
