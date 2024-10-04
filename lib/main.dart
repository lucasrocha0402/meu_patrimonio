import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(PatrimonioApp());
}

class PatrimonioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Patrimônio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Tela inicial é a de login
    );
  }
}
