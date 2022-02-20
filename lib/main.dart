import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoooo/DB&state_managment/DB.dart';
import 'package:todoooo/view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<TaskLogic>(create: (_) => TaskLogic()),

    ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Notes(),
      ),
    );
  }
}

