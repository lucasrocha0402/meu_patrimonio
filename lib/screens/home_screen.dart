import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final List<String> manutencoes = [
      'Fone',
      'Monitor',
      'Teclado',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          // Usando Center para centralizar
          child: Text(
            'Meu patrimônio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Olá, ${user.nome}!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height:
                    20), // Espaçamento entre o texto de boas-vindas e a lista
            Text(
              'Suas manutenções:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: manutencoes.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(manutencoes[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Ícone do perfil
            label: 'Perfil', // Rótulo do botão de perfil
          ),
        ],
        currentIndex: 0, // Indica o índice do item selecionado
        onTap: (index) {
          if (index == 1) {
            // Quando o botão de perfil for pressionado
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userName: user.nome),
              ),
            );
          }
          // Caso precise adicionar lógica para o botão de início, você pode fazê-lo aqui.
        },
      ),
    );
  }
}
