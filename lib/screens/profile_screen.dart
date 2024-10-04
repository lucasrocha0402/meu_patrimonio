import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  ProfileScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, $userName!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Voltar para a tela de login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Remove todas as rotas anteriores
                );
              },
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
