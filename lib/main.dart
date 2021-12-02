import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolocal/UI/add_note.dart';
import 'package:todolocal/utils/database_helper.dart';

import 'UI/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DatabaseHelper(),
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/addNote': (BuildContext context) => AddNote(),
        },
        home: const HomePage(),
        theme: ThemeData(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
              headline1: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              caption: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              button: TextStyle(
                fontSize: 18,
                color: Colors.white,
              )),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
