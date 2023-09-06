import 'package:flutter/material.dart';
import 'package:tiki_wallet/transaction.dart';
import 'package:tiki_wallet/mock/transaction_data.dart' as mock;

class HistoryPage extends StatelessWidget {
  Future<List<Transaction>> fetchData() {
    return Future(() => mock.mockTransactions);
  }

  String checkTransaction(double amount) {
    if (amount > 0) {
      return "From";
    }
    return "To";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Transaction>>(
            future: fetchData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Transaction>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var typeTransaction =
                          checkTransaction(snapshot.data![index].amount);
                      return ListTile(
                        leading: Icon(Icons.money),
                        title: Text(
                            "$typeTransaction ${snapshot.data![index].receiverPhoneNumber}"),
                        subtitle:
                            Text(snapshot.data![index].timestamp.toString()),
                        trailing: Text(snapshot.data![index].amount.toString()),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Text("Network error has occured");
              } else {
                return const Text("Retrieving data");
              }
            }));
  }
}
