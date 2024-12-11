import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/screens/login_screen.dart';
import 'ChangePasswordScreen.dart';
import '../services/api_profile_screen.dart';
import '../models/User_Profile.dart'; 

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserService userService = UserService();
  UserProfileData? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userData = await userService.fetchUserData(widget.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  SizedBox(height: 20),
                  _buildLogoutButton(),
                  SizedBox(height: 20),
                  _buildChangePasswordButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  userData!.nome[0], // Inicial do nome
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              userData!.nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text('CPF: ${userData!.cpf}', style: TextStyle(fontSize: 16)),
            Text('Data de Nascimento: ${userData!.nascimentoFormatado}',
                style: TextStyle(fontSize: 16)),
            Text('Data de Admissão: ${userData!.admissaoFormatado}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
          ],
        ),
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

  ElevatedButton _buildChangePasswordButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 110.0),
      ),
      child: const Text('Alterar Senha'),
    );
  }
}
