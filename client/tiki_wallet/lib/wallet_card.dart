import 'package:flutter/material.dart';

class WalletCard extends StatelessWidget {
  final String title;
  final double balance;
  final Future<void> Function() onPay;
  final Future<void> Function() onTopUp;
  final Future<void> Function() onWithdraw;

  WalletCard({
    required this.title,
    required this.balance,
    required this.onPay,
    required this.onTopUp,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Balance: \$${balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => onPay(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pay'),
                  ),
                  ElevatedButton(
                      onPressed: () => onTopUp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Top Up')),
                  ElevatedButton(
                      onPressed: () => onWithdraw(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Withdraw')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
