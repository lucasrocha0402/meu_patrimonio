import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_screen.dart';
import '../models/patrimonio.dart';
import 'BarcodeScannerScreen.dart';
import 'history_manuetencao_screen.dart'; // Corrigido para minúsculas

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
        backgroundColor: Colors.greenAccent,
        title: Center(
          child: Text(
            'Conecta',
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 50),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 50),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code, size: 50),
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
          SizedBox(height: 30),
          Text(
            'Patrimônios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 2,
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
                    title: Text(
                      '${patrimonios[index].nome} (${patrimonios[index].id})',
                      style: TextStyle(color: Colors.blue),
                    ), // Exibindo apenas o ID
                    onTap: () {
                      // Navegar para a tela de histórico de manutenções
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HistoryManutencaoScreen(
                            patrimonio: patrimonios[index],
                          ),
                        ),
                      );
                    },
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
