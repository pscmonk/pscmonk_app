import 'package:flutter/material.dart';
import "../components/list-posts.dart";

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    final name = settings.name;
    final title = "PSCMonk";
    switch (name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home(title: title));
    }
    return MaterialPageRoute(builder: (_) => Home(title: title));
  }
}
