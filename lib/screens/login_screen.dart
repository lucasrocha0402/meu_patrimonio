import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String? mensagemErro;
  bool _isLoading = false;

  Future<void> login() async {
    final String email = emailController.text;
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

    // Usuários mockados
    List<User> _mockedUsers = [
      User(id: 1, nome: 'Alice', email: 'alice@gmail.com', password: '123456'),
      User(id: 2, nome: 'Bob', email: 'bob@example.com', password: 'abcdef'),
      User(id: 3, nome: 'Lucas', email: 'lucas@gmail.com', password: '123456'),
    ];

    // Simulação de delay como se estivesse fazendo uma requisição
    await Future.delayed(Duration(seconds: 1));

    // Verifique o usuário com base no e-mail e na senha
    User? user = _mockedUsers.firstWhere(
      (user) => user.email == email && user.password == senha,
      orElse: () =>
          User(id: -1, nome: 'Usuário não encontrado', email: '', password: ''),
    );

    setState(() {
      _isLoading = false;
    });

    if (user.id != -1) {
      // Navega para a HomeScreen passando o usuário logado
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } else {
      setState(() {
        mensagemErro = 'Email ou senha incorretos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Meu Patrimônio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: senhaController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : login,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Entrar'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (mensagemErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  mensagemErro!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
