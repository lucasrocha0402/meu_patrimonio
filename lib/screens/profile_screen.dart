import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/patrimonio.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart'; // Importe a tela inicial
import 'BarcodeScannerScreen.dart'; // Ajuste para importar a tela de scanner

class ProfileScreen extends StatefulWidget {
  final String userName;
  final User user;
  final List<Patrimonio> patrimonio;

  ProfileScreen({
    required this.userName,
    required this.user,
    required this.patrimonio,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 1; // Defina um índice inicial

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: widget.user)),
          );
          break;
        case 1:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userName: widget.userName,
                user: widget.user,
                patrimonio: widget.patrimonio,
              ),
            ),
          );
          break;
        case 2:
          if (widget.patrimonio.isNotEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BarcodeScannerScreen(
                  user: widget.user,
                  patrimonios: widget.patrimonio,
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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _showLogoutConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20), // Aumenta o tamanho do botão
                  textStyle:
                      TextStyle(fontSize: 18), // Aumenta o tamanho do texto
                ),
                child: Text('Sair da conta'),
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Logout'),
          content: Text('Você tem certeza que deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _logout(context), // Chama a função de logout
              child: Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // Aqui você pode adicionar a lógica para encerrar a sessão do usuário
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
