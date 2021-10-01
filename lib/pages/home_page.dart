import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:number_inputs/adapters/history_adapter.dart';
import 'package:number_inputs/models/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formkey = GlobalKey<FormState>();
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  int num1 = 0;
  int num2 = 0;
  int? sum;

  submitData(String sum) async {
    if (formkey.currentState!.validate()) {
      Box<History> todoBox = Hive.box<History>('history');
      String date = DateTime.now().toString();
      todoBox.add(History(calculation: sum, date: date));

      setState(() {});
    }
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _light = true;

  _saveTheme() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', _light);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formkey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: sum == null
                          ? Text(
                              '...',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              sum.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            controller: num1Controller,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Enter First Number';
                            //   }
                            //   return null;
                            // },
                            onChanged: (value) {
                              // num2 = value;
                              num1 = int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "First Number",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).cardColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "+",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: num2Controller,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Enter Second Number';
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) {
                            num2 = int.parse(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Second Number",
                            fillColor: Colors.white30,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).cardColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      // if (num2.isNotEmpty) Text(num2)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      child: Text('Calculate'),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Theme.of(context).primaryColor,
                        onSurface: Colors.grey,
                      ),
                      onPressed: () {
                        num1Controller.clear();
                        num2Controller.clear();
                        num1;
                        num2;
                        sum = num1 + num2;
                        print("${num1} + ${num2} = ${sum}");
                        String completeCalculation =
                            ("${num1} + ${num2} = ${sum}");

                        submitData(completeCalculation);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
