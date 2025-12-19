import 'package:flutter/material.dart';
import 'agenda_list.dart';

void main () {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: false,
        ),
      ),
      home: const AgendaList(),
    );
  }
}

  