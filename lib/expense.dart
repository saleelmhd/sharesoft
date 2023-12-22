import 'dart:convert';

import 'package:expense/Connection/connection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  int flag = 0;
  var res;
   double totalExpenses = 0.0;
   int selectedTabIndex = 0;

  void onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {});
  }

  Future<dynamic> viewExpenses() async {
    var response = await get(
      Uri.parse('${Con.url}/expenseview.php'),
    );
    print(response.body);
    print(response.statusCode);
    res = jsonDecode(response.body);
    //  print(res.length);
    if (res[0]['result'] == 'Success') {
      flag = 1;
      totalExpenses = res.fold(
      0.0,
      (previous, current) => previous + double.parse(current['price']),
    );
    } else {
      flag = 0;
    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   Column(
        children: [
          FutureBuilder(
                        future: viewExpenses(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print('ERROR: ${snapshot.error}');
                            return Container();
                          }
                          if (!snapshot.hasData || snapshot.data.length == 0) {
                            print("${snapshot.data}====");
                            print('no data');
                            return Container();
                          }
                
                          return flag == 1
                              ? RefreshIndicator(
                                  onRefresh: _refresh,
                                  child: Expanded(
                                    child: ListView.separated(
                                      controller: ScrollController(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) => Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)),
                                        elevation: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      31, 31, 17, 17)),
                                              borderRadius: BorderRadius.circular(15)),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15)),
                                            contentPadding: const EdgeInsets.all(10),
                                            title: Text(
                                              snapshot.data[index]['title'],
                                            ),trailing:  Text(
                                                  snapshot.data[index]['price'],style: const TextStyle(color: Colors.red),
                                                ),
                                          ),
                                          
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }),
        ],
      ),
    );
  }
}