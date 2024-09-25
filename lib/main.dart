import 'package:flutter/material.dart';
import 'package:kopokopo/API/TransactionApi.dart';
import 'package:provider/provider.dart';
import 'package:kopokopo/Pages/Transaction_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionAPI()),
        // room for more Provider class

      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOPO KOPO',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TransactionPage(),
    );
  }
}
