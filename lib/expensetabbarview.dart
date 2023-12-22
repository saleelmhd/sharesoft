import 'dart:convert';

import 'package:expense/Connection/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Expenseview extends StatefulWidget {
  const Expenseview({super.key});

  @override
  State<Expenseview> createState() => _ExpenseviewState();
}

class _ExpenseviewState extends State<Expenseview> {
  Future<void> addExpense() async {
    var data = {
      'title': titleController.text,
      'price': amountController.text,
    };
    print(data);
    var response =
        await http.post(Uri.parse('${Con.url}/expense.php'), body: data);

    print(response.statusCode);

    var res = jsonDecode(response.body);

    if (res["result"] == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Added Successfully',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop();
    }
  }

   final titleController = TextEditingController();
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
              ),   SizedBox(height: 15,),
              ElevatedButton(onPressed: (){
                addExpense();
              }, child: Text("Add"))
            ],
          ),
    );
  }
}