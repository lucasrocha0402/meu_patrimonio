import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/patrimonio.dart';
import 'BarcodeScannerScreen.dart';
import 'profile_screen.dart';
import '../services/api_home_screen.dart';

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
  late PatrimonioService patrimonioService;

  @override
  void initState() {
    super.initState();
    patrimonioService = PatrimonioService(
        baseUrl: 'https://apiconecta.izzyway.com.br', token: widget.token);
    _fetchPatrimonios();
  }

  Future<void> _fetchPatrimonios() async {
    try {
      patrimonios = await patrimonioService.fetchPatrimonios();
      setState(() {});
    } catch (e) {
      setState(() {
        mensagemErro = e.toString();
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
          ProfileScreen(
            token: widget.token,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: _currentIndex == 0 ? 90 : 50, // Aumenta o tamanho do ícone
            ),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code,
              size: _currentIndex == 1 ? 90 : 50, // Aumenta o tamanho do ícone
            ),
            label: 'Manutenções',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: _currentIndex == 2 ? 90 : 50, // Aumenta o tamanho do ícone
            ),
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
