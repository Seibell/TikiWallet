class Transaction {
  int? id;
  String senderPhoneNumber;
  String receiverPhoneNumber;
  double amount;
  DateTime timestamp;

  Transaction({
    this.id,
    required this.senderPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderPhoneNumber': senderPhoneNumber,
        'receiverPhoneNumber': receiverPhoneNumber,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        senderPhoneNumber: json['senderPhoneNumber'],
        receiverPhoneNumber: json['receiverPhoneNumber'],
        amount: json['amount'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
