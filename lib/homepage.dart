import 'dart:convert';

import 'package:expense/Connection/connection.dart';
import 'package:expense/expense.dart';
import 'package:expense/expensetabbarview.dart';
import 'package:expense/income.dart';
import 'package:expense/incometabview.dart';
import 'package:expense/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int flag = 0;
  var res;
   double totalExpenses = 0.0;
   double totalincome = 0.0;
   int selectedTabIndex = 0;

  void onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  

  // void _addTransaction(String title, double amount) {
  //   setState(() {
  //     transactions.add(Transaction(title: title, amount: amount));
  //   });
  // }
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {});
  }

 Future<List<dynamic>> viewExpenses() async {
    var response = await get(
      Uri.parse('${Con.url}/expenseview.php'),
    );
    print(response.body);
    print(response.statusCode);
    res = jsonDecode(response.body);

    if (res[0]['result'] == 'Success') {
      flag = 1;
      totalExpenses = res.fold(
        0.0,
        (previous, current) => previous + double.parse(current['price']),
      );
      totalincome = res.fold(
        0.0,
        (previous, current) => previous + double.parse(current['pricee']),
      );
    } else {
      flag = 0;
    }
    return res;
  }
 Future<List<dynamic>> viewincometot() async {
    var response = await get(
      Uri.parse('${Con.url}/incomeview.php'),
    );
    print(response.body);
    print(response.statusCode);
    res = jsonDecode(response.body);

    if (res[0]['result'] == 'Success') {
      flag = 1;
      // totalExpenses = res.fold(
      //   0.0,
      //   (previous, current) => previous + double.parse(current['price']),
      // );
      totalincome = res.fold(
        0.0,
        (previous, current) => previous + double.parse(current['pricee']),
        print("${totalincome}////")
      );
    } else {
      flag = 0;
    }
    return res;
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2, // Number of tabs
          child: AlertDialog(backgroundColor: Colors.white,
            content: Container(color: Colors.white,
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Income'),
                      Tab(text: 'Expense'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200, // Adjust the height as needed
                    child: const TabBarView(
                      children: [
                      Center(child: IncomeTabview()),
                        // Content for Tab 2
                       Center(child: Expenseview()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

 
  @override
  void initState() {
    super.initState();

    setState(() {});
    _refresh();
    viewExpenses();
    viewincometot();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Container(
                        height: 80,
                        child:  Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                            'Total Expenses: ${totalExpenses.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.red),
                            ),
                             Text(
                              'Totel Income:${totalincome.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ))),
                  ),
                ),
                const SizedBox(height: 20,),
             Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TabBarExpense(
                              text: '   Expense   ',
                              isSelected: selectedTabIndex == 0,
                              onTap: () {
                                onTabSelected(0);
                              }),
                          TabBarExpense(
                              text: 'Income',
                              isSelected: selectedTabIndex == 1,
                              onTap: () {
                                onTabSelected(1);
                              }),
                          
                        ],
                      ),
                    ),
                  ),
                ),          
                 Container(height: 600,
                   child: TabBarView(
                     physics: const BouncingScrollPhysics(),
                     children: [
                       if (selectedTabIndex == 0) const Expenses(),
                       if (selectedTabIndex == 1) const Income(),
                      
                     ],
                   ),
                 ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCustomDialog(context),
          child: const Icon(Icons.add),
         
        ),
      ),
    );
  }
}
