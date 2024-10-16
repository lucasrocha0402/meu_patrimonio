import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/patrimonio.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // Removido o BottomNavigationBar
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
