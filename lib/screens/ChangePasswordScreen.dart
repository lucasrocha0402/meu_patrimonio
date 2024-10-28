import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final storage = FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await storage.read(key: 'jwt_token');
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.isEmpty ||
        _currentPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Todos os campos são obrigatórios.');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar('A nova senha e a confirmação não coincidem.');
      return;
    }

    final response = await http.post(
      Uri.parse('https://apiconecta.izzyway.com.br/api/Usuario/AlterarSenha'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'senhaAtual': _currentPasswordController.text,
        'novaSenha': _newPasswordController.text,
        'repetirSenha': _confirmPasswordController.text, // Corrigido aqui
      }),
    );

    if (response.statusCode == 200) {
      _showSnackBar('Senha alterada com sucesso!');
      Navigator.pop(context);
    } else {
      final responseBody = jsonDecode(response.body);
      _showSnackBar(
          'Erro: ${responseBody['mensagem'] ?? 'Não foi possível alterar a senha.'}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha Atual'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirme a Nova Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
