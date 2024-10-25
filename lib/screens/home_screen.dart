import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/patrimonio.dart';
import 'BarcodeScannerScreen.dart';
import 'profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final User user;
  final String token;
  final String primeiroNome;

  HomeScreen({
    required this.user,
    required this.token,
    required this.primeiroNome,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Patrimonio> patrimonios = [];
  String? mensagemErro;

  @override
  void initState() {
    super.initState();
    _fetchPatrimonios();
  }

  Future<void> _fetchPatrimonios() async {
    final String url =
        'https://apiconecta.izzyway.com.br/api/Patrimonio/GetTodosBemColaborador';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['result'];
        setState(() {
          patrimonios = data.map((item) {
            return Patrimonio(
              nome: item['nome'],
              serie: item['serie'].toDouble(),
              categoria: item['categoria'],
              marca: item['marca'],
              garantia: item['garantia'],
              colaborador: item['colaborador'],
              fotos: List<String>.from(item['fotos'] ?? []),
              codigo: item['codigo'] ??
                  '', // Ensure these attributes exist in your model
              localizacao:
                  item['localizacao'] ?? '', // Initialize appropriately
              status: item['status'] ?? '', // Initialize appropriately
            );
          }).toList();
        });
      } else {
        setState(() {
          mensagemErro = 'Erro ao obter patrimônios: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        mensagemErro = 'Erro ao se conectar ao servidor: $e';
      });
    }
  }

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
        backgroundColor: const Color.fromARGB(255, 123, 209, 168),
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
          BarcodeScannerScreen(user: widget.user, patrimonios: patrimonios),
          ProfileScreen(user: widget.user, patrimonio: patrimonios),
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
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
            'Olá, ${widget.primeiroNome}!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Text(
            'Patrimônios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2),
          SizedBox(height: 10),
          if (mensagemErro != null)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(mensagemErro!, style: TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: patrimonios.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text(
                      '${patrimonios[index].nome})',
                      style: TextStyle(color: Colors.blue),
                    ),
                    subtitle:
                        Text('Colaborador: ${patrimonios[index].colaborador}'),
                    onTap: () {
                      // Ação ao clicar no item
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
