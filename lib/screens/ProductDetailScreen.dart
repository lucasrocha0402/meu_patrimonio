import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/user.dart';
import 'package:patrimonio_izzy_app/screens/home_screen.dart';
import '../models/patrimonio.dart';
import 'fotos_screen.dart';
import 'manutencao_screen.dart';
import 'adicionar_foto_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Patrimonio patrimonio;
  final User user;
  final List<Patrimonio> patrimonios;

  ProductDetailScreen({
    required this.patrimonio,
    required this.user,
    required this.patrimonios,
  });

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
                  user: user,
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
                        ManutencaoScreen(patrimonio: patrimonio),
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
              'Nome: ${patrimonio.nome}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'ID: ${patrimonio.id}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Série: ${patrimonio.serie}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Categoria: ${patrimonio.categoria}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Marca: ${patrimonio.marca}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Garantia: ${patrimonio.garantia}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'Colaborador: ${patrimonio.colaborador}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FotosScreen(
                  fotos: patrimonio.fotos,
                  patrimonio: patrimonio,
                  user: user,
                  patrimonios: patrimonios,
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
      List<String> updatedPhotos = List.from(patrimonio.fotos)
        ..addAll(novasFotos);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FotosScreen(
            fotos: updatedPhotos,
            patrimonio: patrimonio,
            user: user,
            patrimonios: patrimonios,
          ),
        ),
      );
    }
  }
}
