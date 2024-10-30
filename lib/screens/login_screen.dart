import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:patrimonio_izzy_app/layers_login/configLayou.dart';
import 'home_screen.dart';
import '../models/user.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Patrimônio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final storage = FlutterSecureStorage();
  String? mensagemErro;
  bool _isLoading = false;
  bool _obscureText = true;
  bool _isChecked = false;
  double _containerHeight = 800;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  double _topPosition = 290; // Posição inicial

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_focusListener);
    passwordFocusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_focusListener);
    passwordFocusNode.removeListener(_focusListener);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _focusListener() {
    setState(() {
      _topPosition =
          (emailFocusNode.hasFocus || passwordFocusNode.hasFocus) ? 200 : 290;
    });
  }

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
                token: token,
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

  void _onInputFocus() {
    setState(() {
      _containerHeight = 400;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagen/primaryBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 130,
              left: 59,
              child: Image.asset(
                'assets/imagen/enterprise_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            Positioned(
              top: 200,
              left: 59,
              child: Text(
                'Conecta',
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'Poppins-Medium',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 290,
              right: 16,
              child: Container(
                width: MediaQuery.of(context).size.width - 64,
                height: 550,
                decoration: BoxDecoration(
                  color: layerOneBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Primeiro Container
                      Container(
                        width: MediaQuery.of(context).size.width - 64,
                        height: 500,
                        decoration: BoxDecoration(
                          color: layerTwoBg,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 70, horizontal: 30),
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.white30),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 30.0),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: senhaController,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.white30),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 30.0),
                                ),
                                obscureText: _obscureText,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : login,
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text('Entrar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.black,
                                    activeColor: Colors.green,
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                  Text('Deixar senha salva'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
