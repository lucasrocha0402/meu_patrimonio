import 'package:flutter/material.dart'; // Biblioteca principal para a construção da interface gráfica do Flutter.
import 'package:patrimonio_izzy_app/layers_login/configLayou.dart'; //  o arquivo de configuração do layout da tela.
import 'home_screen.dart'; // a tela de destino após o login ser bem-sucedido.
import '../models/user.dart'; // classe que representa os dados de um usuário.
import '../services/api_loguin_services.dart'; // Serviço responsável pelas operações de login e interação com a API.

//LoginScreen é a tela inicial do aplicativo, configurando o tema (cor primária e a fonte) e
//indicando que a tela inicial será o widget LoginPage.
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

//LoginPage é um widget StatefulWidget, o que significa que ele tem um estado que pode mudar.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

//No estado (_LoginPageState): Controladores de texto (emailController e senhaController)
// são usados para pegar o texto inserido nos campos de email e senha.
// mensagemErro: Armazena mensagens de erro para exibir ao usuário.
// _isLoading: Flag que indica se o login está em andamento (para mostrar um indicador de carregamento).
// _obscureText: Controla se a senha deve ser mostrada ou oculta (ícone de olho).
// _isChecked: Para controlar o estado de um checkbox ("Deixar senha salva").
// apiService: Instância do serviço responsável por interagir com a API de login.
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode senhaFocusNode = FocusNode();
  String? mensagemErro;
  bool _isLoading = false;
  bool _obscureText = true;
  bool _isChecked = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    emailFocusNode.addListener(() {
      setState(() {});
    });

    senhaFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    senhaFocusNode.dispose();
    super.dispose();
  }

//Função login: Esta função é chamada quando o usuário tenta fazer login. Ela realiza os seguintes passos:
// Verifica se os campos de email e senha não estão vazios.
// Exibe um indicador de carregamento (_isLoading).
// Chama os métodos da apiService para tentar realizar o login e pegar as informações do usuário.
// Caso o login seja bem-sucedido, navega para a tela HomeScreen e passa os dados do usuário, como o token e o primeiro nome.
// Se ocorrer algum erro (por exemplo, credenciais inválidas), exibe uma mensagem de erro.
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

    try {
      final token = await apiService.login(email, senha);
      final userInfo = await apiService.getUserInfo(token);

      String nomeCompleto = userInfo['result']['nome'];
      String primeiroNome = nomeCompleto.split(' ').first;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: User(email: email, password: '', token: token),
            primeiroNome: primeiroNome,
            token: token,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        mensagemErro = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Scaffold: Um widget básico para a estrutura visual da tela.
// Imagem de fundo: O fundo é configurado para exibir uma imagem (primaryBg.png).
// Formulário de login:
// Campos de texto para o usuário inserir email e senha.
// Botão de login: Desabilitado durante o carregamento (indicador de progresso é mostrado).
// Checkbox: Permite ao usuário marcar a opção de "Deixar senha salva".
// Mensagens de erro: Se houver algum erro (como campos vazios ou falha no login), uma mensagem será exibida abaixo do botão de login.

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
                                focusNode: emailFocusNode,
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
                                focusNode: senhaFocusNode,
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
                              SizedBox(height: 20),
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
