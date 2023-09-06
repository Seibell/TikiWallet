import 'package:tiki_wallet/login_view.dart';
import 'package:tiki_wallet/nfc_page.dart';
import 'package:tiki_wallet/top_up_page.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'wallet_card.dart';
import 'history_page.dart';
import 'online_payment_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  double? onlineWalletBalance; //populated by some API call
  double? offlineWalletBalance; //populated by some API call
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchWalletBalance();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> fetchWalletBalance() async {
    // fake api call
    await Future.delayed(Duration(seconds: 1));
    print("Fetching wallet balance");

    setState(() {
      // fake values
      onlineWalletBalance = 100.50;
      offlineWalletBalance = 200.75;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text('Tiki Wallet'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    // Change LOGGED_IN in db to false
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
              ),
            ],
            bottom: _currentIndex == 0
                ? TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Online Wallet'),
                      Tab(text: 'Offline Wallet'),
                    ],
                  )
                : null,
          ),
          body: _currentIndex == 0
              ? onlineWalletBalance == null || offlineWalletBalance == null
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        WalletCard(
                          title: 'Online Wallet',
                          balance: onlineWalletBalance!,
                          onPay: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OnlinePaymentPage(
                                      accountBalance: onlineWalletBalance!)),
                            );
                          },
                          onTopUp: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopUpPage()),
                            );
                          },
                          onWithdraw: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopUpPage()),
                            );
                          },
                        ),
                        WalletCard(
                          title: 'Offline Wallet',
                          balance: offlineWalletBalance!,
                          onPay: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NFCPage()),
                            );
                          },
                          onTopUp: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopUpPage()),
                            );
                          },
                          onWithdraw: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopUpPage()),
                            );
                          },
                        ),
                      ],
                    )
              : _currentIndex == 1
                  ? NFCPage()
                  : HistoryPage(),
          bottomNavigationBar: ConvexAppBar(
            backgroundColor: Colors.brown,
            items: const [
              TabItem(icon: Icons.home, title: "Home"),
              TabItem(icon: Icons.attach_money, title: "Pay"),
              TabItem(icon: Icons.book, title: "History"),
            ],
            initialActiveIndex: _currentIndex,
            onTap: _onItemTapped,
          ),
        ),
      ],
    );
  }
}