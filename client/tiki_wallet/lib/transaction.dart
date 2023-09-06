class Transaction {
  String type;
  String senderPhoneNumber;
  String receiverPhoneNumber;
  String transactionType;
  double amount;
  DateTime timestamp;
  bool approved;

  Transaction(
      {required this.type,
      required this.senderPhoneNumber,
      required this.receiverPhoneNumber,
      required this.transactionType,
      required this.amount,
      required this.timestamp,
      required this.approved});

  Map<String, dynamic> toJson() => {
        'type': type,
        'senderPhoneNumber': senderPhoneNumber,
        'receiverPhoneNumber': receiverPhoneNumber,
        'transactionType': transactionType,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
        'approved': approved,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: json['type'],
        senderPhoneNumber: json['senderPhoneNumber'],
        receiverPhoneNumber: json['receiverPhoneNumber'],
        transactionType: json['transactionType'],
        amount: json['amount'],
        timestamp: DateTime.parse(json['timestamp']),
        approved: json['approved'],
      );
}
