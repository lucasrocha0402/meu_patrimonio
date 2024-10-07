import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patrimonio.dart';
import 'fotos_screen.dart';
import 'manutencao_screen.dart'; // Certifique-se de ter a tela de manutenção
import 'adicionar_foto_screen.dart'; // Certifique-se de ter a tela de adicionar foto

class ProductDetailScreen extends StatelessWidget {
  final Patrimonio patrimonio;

  ProductDetailScreen({required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Patrimônio'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdicionarFotoScreen(patrimonioId: patrimonio.id),
                  ),
                );
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
            SizedBox(height: 10),
            Text(
              'ID: ${patrimonio.id}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Valor: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(patrimonio.valor)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fotos:', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FotosScreen(fotos: patrimonio.fotos),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ação executada com sucesso!')),
                );
              },
              child: Text('Executar Ação'),
            ),
          ],
        ),
      ),
    );
  }
}
