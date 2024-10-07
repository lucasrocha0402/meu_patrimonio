import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_screen.dart';
import '../models/patrimonio.dart';
import 'package:intl/intl.dart';
import 'BarcodeScannerScreen.dart'; // Corrigido para minúsculas

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Patrimonio> patrimonios = [
    Patrimonio(id: '1', nome: 'Fone', valor: 4.00),
    Patrimonio(id: '2', nome: 'Teclado', valor: 5.00),
    Patrimonio(id: '3', nome: 'Monitor', valor: 7.00),
    // Adicione mais itens conforme necessário
  ];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      switch (index) {
        case 0:
          // Já está na tela inicial, não faz nada
          break;
        case 1:
          // Navegar para a tela de perfil
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userName: widget.user.nome,
                user: widget.user,
                patrimonio: patrimonios,
              ),
            ),
          );
          break;
        case 2:
          if (patrimonios.isNotEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BarcodeScannerScreen(
                  user: widget.user,
                  patrimonios: patrimonios,
                ),
              ),
            );
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Meu Patrimônio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomePage(),
          ProfileScreen(
            userName: widget.user.nome,
            user: widget.user,
            patrimonio: patrimonios,
          ),
          // Aqui você pode adicionar a tela de manutenções, se necessário
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Manutenções',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Olá, ${widget.user.nome}!', // Mostrando o nome do usuário
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Seus Patrimônios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: patrimonios.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text(patrimonios[index].nome),
                    subtitle: Text(
                      'Valor: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(patrimonios[index].valor)}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
