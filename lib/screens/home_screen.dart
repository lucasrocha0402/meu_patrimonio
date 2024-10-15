import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/patrimonio.dart';
import 'BarcodeScannerScreen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Patrimonio> patrimonios = [
    Patrimonio(
      id: '1',
      nome: 'Fone',
      serie: 123456,
      categoria: 'Eletrônicos',
      marca: 'Marca A',
      garantia: '12 meses',
      colaborador: 'João Silva',
    ),
    Patrimonio(
      id: '2',
      nome: 'Teclado',
      serie: 654321,
      categoria: 'Periféricos',
      marca: 'Marca B',
      garantia: '24 meses',
      colaborador: 'Maria Oliveira',
    ),
    Patrimonio(
      id: '3',
      nome: 'Monitor',
      serie: 789012,
      categoria: 'Monitores',
      marca: 'Marca C',
      garantia: '36 meses',
      colaborador: 'Carlos Pereira',
    ),
  ];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
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
          BarcodeScannerScreen(
            user: widget.user,
            patrimonios: patrimonios,
          ),
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
            icon: Icon(Icons.qr_code, size: 50),
            label: 'Manutenções',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 50),
            label: 'Perfil',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple, // Cor do ícone selecionado
        unselectedItemColor: Colors.black, // Cor dos ícones não selecionados
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
            'Olá, ${widget.user.nome}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Text(
            'Patrimônios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2),
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
                    ),
                    onTap: () {},
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
