import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final storage = FlutterSecureStorage();
  String? mensagemErro;
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        mensagemErro = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      mensagemErro = null;
    });

    final String url = 'https://apiconecta.izzyway.com.br/api/Autentication';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final String token = data['result'];
          await storage.write(key: 'jwt_token', value: token);
          await _getUserInfo(token, email);
        } else {
          setState(() {
            mensagemErro = data['message'] ?? 'Email ou senha incorretos.';
          });
        }
      } else {
        setState(() {
          mensagemErro = 'Erro na autenticação: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        mensagemErro = 'Erro ao se conectar ao servidor.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getUserInfo(String token, String email) async {
    final String url =
        'https://apiconecta.izzyway.com.br/api/Usuario/GetInformacoes';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('User info response status: ${response.statusCode}');
      print('User info response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String nomeCompleto = data['result']['nome'];
        String primeiroNome = nomeCompleto.split(' ').first;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: User(
                email: email,
                password: '', // Evitar armazenar senha
                token: token, // Armazenar o token
              ),
              primeiroNome: primeiroNome,
              token: token,
            ),
          ),
        );
      } else {
        setState(() {
          mensagemErro =
              'Erro ao obter informações do usuário: ${response.reasonPhrase}';
        });
        print('Erro: ${response.body}');
      }
    } catch (e) {
      print('Error ao obter informações do usuário: $e');
      setState(() {
        mensagemErro =
            'Erro ao se conectar ao servidor para obter informações.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: const Color.fromARGB(255, 123, 209, 168),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imagen/enterprise_icon.png', height: 200),
              Text(
                'Conecta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Entrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                ),
              ),
              if (mensagemErro != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child:
                      Text(mensagemErro!, style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
