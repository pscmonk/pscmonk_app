import 'package:flutter/material.dart';
import "route/RouteGen.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MaterialApp(
          title: 'PSC Monk',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: "/",
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
