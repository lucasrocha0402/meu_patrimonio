import 'package:flutter/material.dart';
import '../models/patrimonio.dart';
import 'profile_screen.dart';
import 'home_screen.dart'; // Certifique-se de ter esta tela
import '../models/user.dart';

class HistoryManutencaoScreen extends StatelessWidget {
  final Patrimonio patrimonio;
  final String userName; // Nome do usuário
  final User user; // Objeto do usuário

  HistoryManutencaoScreen({
    required this.patrimonio,
    required this.userName,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Manutenções '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patrimônio: ${patrimonio.nome}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(title: Text('Manutenção 1')),
                  ListTile(title: Text('Manutenção 2')),
                  ListTile(title: Text('Manutenção 3')),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 50),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code, size: 50),
            label: 'Manutenções',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 50),
            label: 'Perfil',
          ),
        ],
        currentIndex: 1, // Exibindo 'Manutenções' como ativo
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    user: user,
                    token: '',
                    primeiroNome: '',
                  ), // Passando o usuário
                ),
              );
              break;
            case 1:
              // Já estamos na tela de manutenções
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    // Passando o nome do usuário
                    user: user, // Passando o objeto do usuário
                    patrimonios: [],
                    token: '', // Passe a lista de patrimônio, se necessário
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
