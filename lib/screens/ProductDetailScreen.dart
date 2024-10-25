import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/user.dart';
import 'package:patrimonio_izzy_app/screens/home_screen.dart';
import '../models/patrimonio.dart';
import 'fotos_screen.dart';
import 'manutencao_screen.dart';
import 'adicionar_foto_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Patrimonio patrimonio;
  final User user;
  final List<Patrimonio> patrimonios;

  ProductDetailScreen({
    required this.patrimonio,
    required this.user,
    required this.patrimonios,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 209, 168),
        title: Text(
          'Detalhes do Patrimônio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: widget.user,
                  token: '',
                  primeiroNome: '',
                ),
              ),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'manutencao') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManutencaoScreen(patrimonio: widget.patrimonio),
                  ),
                );
              } else if (value == 'adicionar_foto') {
                _adicionarFoto(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'manutencao',
                child: Text('Manutenção'),
              ),
              PopupMenuItem<String>(
                value: 'adicionar_foto',
                child: Text('Adicionar Foto'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${widget.patrimonio.nome}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Código: ${widget.patrimonio.codigo}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Série: ${widget.patrimonio.serie ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Categoria: ${widget.patrimonio.categoria ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Marca: ${widget.patrimonio.marca}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Garantia: ${widget.patrimonio.garantia ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Localização: ${widget.patrimonio.localizacao}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Status: ${widget.patrimonio.status}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Ambiente: ${widget.patrimonio.ambiente ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Pessoa: ${widget.patrimonio.pessoa ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Colaborador: ${widget.patrimonio.colaborador ?? "Não disponível"}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info, size: 50),
            label: 'Dados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library, size: 50),
            label: 'Fotos',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FotosScreen(
                  fotos: widget.patrimonio.fotos,
                  patrimonio: widget.patrimonio,
                  user: widget.user,
                  patrimonios: widget.patrimonios,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _adicionarFoto(BuildContext context) async {
    final novasFotos = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarFotoScreen(),
      ),
    );

    if (novasFotos != null) {
      setState(() {
        widget.patrimonio.fotos
            .addAll(novasFotos); // Update the patrimonio's photos directly
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FotosScreen(
            fotos: widget.patrimonio.fotos,
            patrimonio: widget.patrimonio,
            user: widget.user,
            patrimonios: widget.patrimonios,
          ),
        ),
      );
    }
  }
}
