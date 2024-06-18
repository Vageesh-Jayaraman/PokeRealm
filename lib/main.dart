import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex/utilities/startingPage.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox'); //Database
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
      theme: ThemeData.dark(),
      home: StartingPage(),
    );
  }
}
