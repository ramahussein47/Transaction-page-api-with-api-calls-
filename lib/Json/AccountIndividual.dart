import 'package:flutter/material.dart';

class Account extends ChangeNotifier {
  final String accountId;
  final String accountName;
  final double balance;

  Account({
    required this.accountId,
    required this.accountName,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountid'],
      accountName: json['accountName'],
      balance: json['balance'] != null ? double.parse(json['balance'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountid': accountId,
      'accountName': accountName,
      'balance': balance,
    };
  }
}
