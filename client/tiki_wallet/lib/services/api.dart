import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiki_wallet/model/user.dart';
import 'package:tiki_wallet/transaction.dart';

class API {
  final String baseUrl;

  API(this.baseUrl);

  // Account routes
  Future<User> getAccount(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/account/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      const Dialog(
        child: Text("Network Error Occured"),
      );
      throw Exception("User not found");
    }
  }

  Future<Map<String, dynamic>> getAllAccounts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/account/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to load accounts'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getOtps() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/account/otp'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to load OTPs'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteAccount(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/account/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to delete account'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteAll() async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/account/all'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to delete all accounts'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Auth Routes
  Future<Map<String, dynamic>> testCreateUser(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/test'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to create user'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to log in'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to register'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendVerification(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/generate-otp'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to generate OTP'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verify(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to verify OTP'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Transaction routes
  Future<Map<String, dynamic>> onlineTransfer(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transaction/onlineTransfer'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to transfer online'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<List<Transaction>> getTransactions(int accountId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/transaction/getTransactions/$accountId'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<Transaction> incomingtransactions = data["incomingTransactions"]
          .map((transaction) => Transaction.fromJson(transaction));
      List<Transaction> outgoingtransactions = data["outgoingTransactions"]
          .map((transaction) => Transaction.fromJson(transaction));
      List<Transaction> result = List.from(incomingtransactions)
        ..addAll(outgoingtransactions);
      return result;
    } else {
      const Dialog(
        child: Text("Network Error Occured"),
      );
      throw Exception("Network Error");
    }
  }
}
