import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/patrimonio.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import 'BarcodeScannerScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final User user;
  final List<Patrimonio> patrimonio;

  const ProfileScreen({
    required this.userName,
    required this.user,
    required this.patrimonio,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 2; // Ajustado para que o perfil seja o selecionado

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: widget.user),
            ),
          );
          break;
        case 1:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BarcodeScannerScreen(
                user: widget.user,
                patrimonios: widget.patrimonio,
              ),
            ),
          );
          break;
        case 2:
          // Já está na tela de perfil, não faz nada
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Center(
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
        padding: const EdgeInsets.all(47.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: _buildLogoutButton(),
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
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple, // Cor do ícone selecionado
        unselectedItemColor: Colors.black, // Cor dos ícones não selecionados
        onTap: _onItemTapped,
      ),
    );
  }

  ElevatedButton _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () => _showLogoutConfirmationDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 110.0),
      ),
      child: const Text('Sair da conta'),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Você tem certeza que deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _logout(context),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
