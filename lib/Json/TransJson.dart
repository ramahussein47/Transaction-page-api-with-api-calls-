import 'package:flutter/material.dart';

class Transaction extends ChangeNotifier {
  final String id;
  final String accountId;
  double amount;
  String type;
  final double? balance;

  Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    this.balance,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      accountId: json['account_id'],
      amount: json['amount'],
      type: json['type'],
      balance: json['balance'] != null ? double.parse(json['balance'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'amount': amount,
      'type': type,
      'balance': balance,
    };
  }

  void updateTransaction(double newAmount, String newType) {
    amount = newAmount;
    type = newType;
    notifyListeners();
  }
}
