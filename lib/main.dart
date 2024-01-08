import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WeatherScreen(),
        title: 'Weather',
        theme: ThemeData.dark(
          useMaterial3: true
          ),
        
        );
  }
}
