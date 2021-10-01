import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:number_inputs/adapters/history_adapter.dart';
import 'package:number_inputs/pages/history_page.dart';
import 'package:number_inputs/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryAdapter());
  await Hive.openBox<History>('history');

  runApp(const MyApp());
}

ThemeData _darkTheme = ThemeData(
  hintColor: Colors.white,
  brightness: Brightness.dark,
  primaryColor: const Color(0xff07FFCD),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    foregroundColor: Colors.white,
  ),
);

ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: Colors.grey.shade200,
  primaryColor: const Color(0xff07FFCD),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return const ThemeSwitch();
  }
}

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool? _light = true;

  _saveTheme(_lightFromClick) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences pref = prefs;
    pref.setBool('theme', _lightFromClick);
  }

  @override
  void initState() {
    _getTheme();
    super.initState();
  }

  void _getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _light = prefs.getBool("theme");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _light! ? _lightTheme : _darkTheme,
      home: Builder(
        builder: (context) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Number Calculator",
              ),
              elevation: 0,
              leading: InkWell(
                onTap: () {
                  if (_light != null) {
                    setState(() {
                      _saveTheme(_light);
                      _light = !_light!;

                      //saving darkmode info to the shared prefferences
                    });
                  } else {
                    _light = true;
                  }
                },
                child: _light!
                    ? const Icon(
                        Icons.dark_mode_outlined,
                      )
                    : const Icon(
                        Icons.light_mode_outlined,
                      ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryPage()),
                      );
                    },
                    child: Icon(
                      Icons.list_outlined,
                    ),
                  ),
                ),
              ],
            ),
            body: const HomePage(),
          ),
        ),
      ),
    );
  }
}
