import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopokopo/Json/AccountIndividual.dart';
import 'package:kopokopo/Json/TransJson.dart';
import 'package:kopokopo/server/Urls.dart';

class TransactionAPI extends ChangeNotifier {


  // List to hold fetched transactions
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Function for fetching transactions
  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('$codeServer/transactions'));

      // Check for a successful response from the server
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        _transactions = jsonResponse.map((transaction) => Transaction.fromJson(transaction)).toList();
        notifyListeners(); //When data is changed notify UI
      } else {
        _serverError(response);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Function for creating transactions
  Future<Transaction> createTransaction(String accountId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$codeServer/transactions'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'account_id': accountId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 201) {
        final newTransaction = Transaction.fromJson(json.decode(response.body));
        _transactions.add(newTransaction); // Add to local transactions list
        notifyListeners(); // Notify listeners
        return newTransaction;
      } else {
        _serverError(response);
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
    throw Exception('Failed to create transaction');
  }

  // Function for fetching a transaction by ID
  Future<Transaction> fetchTransactionById(String id) async {
    try {
      final response = await http.get(Uri.parse('$codeServer/transactions/$id'));

      if (response.statusCode == 200) {
        final transaction = Transaction.fromJson(json.decode(response.body));
        notifyListeners(); // Notify listeners
        return transaction;
      } else {
        _serverError(response);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
    throw Exception('Failed to load the transaction');
  }

  // Function for fetching an account by ID
  Future<Account> fetchAccountById(String id) async {
    try {
      final response = await http.get(Uri.parse('$codeServer/accounts/$id'));

      if (response.statusCode == 200) {
        final account = Account.fromJson(jsonDecode(response.body));
        notifyListeners(); // Notify listeners
        return account;
      } else {
        _serverError(response);
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
    throw Exception('Failed to load account');
  }

  void _serverError(http.Response response) {
    // Handle different HTTP status codes
    switch (response.statusCode) {
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized access: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not found: ${response.body}');
      case 500:
        throw Exception('Server error: ${response.body}');
      case 503:
        throw Exception('Service unavailable: ${response.body}');
      default:
        throw Exception('Unexpected error: ${response.statusCode} - ${response.body}');
    }
  }
}
