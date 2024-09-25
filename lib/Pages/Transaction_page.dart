import 'package:flutter/material.dart';
import 'package:kopokopo/API/TransactionApi.dart';
import 'package:provider/provider.dart';


class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final accountController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<TransactionAPI>(context, listen: false).fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transaction Form',
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TransactionAPI>(
          builder: (context, transactionAPI, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: accountController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            hintText: "Account ID",
                          ),
                          validator: (String? value) {
                            return (value != null && value.isEmpty)
                                ? "The ID is invalid "
                                : null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: amountController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            hintText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            String error = 'Please enter an amount';
                            String validAmount = 'Please enter a valid amount';
                            if (value == null || value.isEmpty) {
                              return error;
                            }
                            if (double.tryParse(value) == null) {
                              return validAmount;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true) {
                              final accountId = accountController.text;
                              final amount = double.parse(amountController.text);

                              try {
                                await transactionAPI.createTransaction(accountId, amount);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'The account $accountId has been approved for amount $amount'),
                                ));

                                await transactionAPI.fetchTransactions();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Error: $e'),
                                ));
                              }
                            }
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Historical Transactions',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Consumer<TransactionAPI>(
                    builder: (context, transactionAPI, child) {
                      final transactions = transactionAPI.transactions;

                      if (transactions.isEmpty) {


                     return Column(
               mainAxisAlignment: MainAxisAlignment.center,
  children: [
       Icon(Icons.library_books_sharp,
       size: 50,
       color: Colors.grey,),
       SizedBox(height: 20,),
       Text('No Transactions Found',
       style: TextStyle(
       fontSize: 18,
color: Colors.grey,

       ),)


  ],




                     );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Card(
                            shadowColor: Colors.blueGrey[300],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transferred \$${transaction.amount.abs()} ${transaction.amount < 0 ? "from" : "to"} account ${transaction.accountId}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  if (transaction.balance != null)
                                    Text(
                                      'The current account balance is \$${transaction.balance}',
                                      style: const TextStyle(fontSize: 14),
                                    )
                                  else
                                    const Text(
                                      'No account balance shown as this transaction was submitted from another client',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
