import 'package:flutter/material.dart';

class TopUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              color: Colors.brown,
              elevation: 4.0,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '\$100.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Top Up Options',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TopUpOption(amount: '\$10'),
            TopUpOption(amount: '\$20'),
            TopUpOption(amount: '\$50'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Custom Amount',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement top-up functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0), // Adjust the vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Make it more rounded
                    ),
                  ),
                  child: Text(
                    'Top Up',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopUpOption extends StatelessWidget {
  final String amount;

  TopUpOption({required this.amount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Top Up $amount',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Implement top-up functionality with this amount
      },
    );
  }
}
