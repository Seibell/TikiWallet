class User {
  int id;
  int phone_number;
  String username;
  double online_balance;

  User({
    required this.id,
    required this.phone_number,
    required this.username,
    required this.online_balance,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phone_number,
        'username': username,
        'online_balance': online_balance,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        phone_number: json['phone_number'],
        username: json['username'],
        online_balance: double.parse(json['online_balance']),
      );
}
