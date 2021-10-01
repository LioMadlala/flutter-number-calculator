import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:number_inputs/adapters/history_adapter.dart';
import 'package:number_inputs/models/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "History",
          ),
          elevation: 0,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<History>('history').listenable(),
          builder: (context, Box<History> box, _) {
            if (box.values.isEmpty) {
              return const Center(
                child: Text("No history calculations available!",
                    style: TextStyle(fontFamily: 'Montserrat')),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: const Text(
                      "Tap and hold to delete",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        History? history = box.getAt(index);
                        DateTime dt = DateTime.parse(history!.date);
                        String time = timeago.format(dt, locale: 'en');
                        return ListTile(
                          onLongPress: () async {
                            await box.deleteAt(index);
                          },
                          title: Text(
                            history.calculation,
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Montserrat'),
                          ),
                          subtitle: Text(
                            "${timeago.format(dt, locale: 'en')}",
                            style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                color: Colors.blue),
                          ),
                        );
                      }),
                ),
              ],
            );
          },

          // ),
        ),
      ),
    );
  }
}
