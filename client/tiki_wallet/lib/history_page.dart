import 'package:flutter/material.dart';

// this is just filler for now, listview of transactions

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction ${index + 1}'),
            subtitle: Text('Details of transaction ${index + 1}'),
          );
        },
      ),
    );
  }
}
