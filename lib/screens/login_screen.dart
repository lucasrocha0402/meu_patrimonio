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
  bool _obscureText = true; // For password visibility toggle

  // Mocked user data
  List<User> _mockedUsers() {
    return [
      User(id: 1, nome: 'Alice', email: 'alice@gmail.com', password: '123456'),
      User(id: 2, nome: 'Bob', email: 'bob@example.com', password: 'abcdef'),
      User(id: 3, nome: 'Lucas', email: 'lucas@gmail.com', password: '123456'),
    ];
  }

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

    // Simulação de delay como se estivesse fazendo uma requisição
    await Future.delayed(Duration(seconds: 1));

    // Verifique o usuário com base no e-mail e na senha
    User? user = _mockedUsers().firstWhere(
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
          backgroundColor: const Color.fromARGB(255, 123, 209, 168),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/imagen/enterprise_icon.png',
                  height: 200,
                ),
                Text(
                  'Conecta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
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
                    child: Text(
                      mensagemErro!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
