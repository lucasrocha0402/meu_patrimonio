import 'package:flutter/material.dart';
import '../models/patrimonio.dart';
import 'ProductDetailScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class SearchPatrimonioScreen extends StatefulWidget {
  final User user; // Assuming User is a defined class
  final List<Patrimonio> patrimonios;

  SearchPatrimonioScreen({
    required this.user,
    required this.patrimonios,
  });

  @override
  _SearchPatrimonioScreenState createState() => _SearchPatrimonioScreenState();
}

class _SearchPatrimonioScreenState extends State<SearchPatrimonioScreen> {
  Patrimonio? foundPatrimonio;
  bool isLoading = false;

  void filterPatrimonio(String query) async {
    if (query.isEmpty) {
      setState(() {
        foundPatrimonio = null;
      });
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });

    final String url =
        'https://apiconecta.izzyway.com.br/api/Patrimonio/GetBemPorCodigo?codigo=$query';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['result'];
        setState(() {
          foundPatrimonio = data != null
              ? Patrimonio(
                  nome: data['nome'],
                  serie: data['serie'].toDouble(),
                  categoria: data['categoria'],
                  marca: data['marca'],
                  garantia: data['garantia'],
                  colaborador: data['colaborador'],
                  fotos: List<String>.from(data['fotos'] ?? []),
                  codigo: data['codigo'] ?? '',
                  localizacao: data['localizacao'] ?? '',
                  status: data['status'] ?? '',
                )
              : null;
        });
      } else {
        _showErrorSnackBar(
            'Erro ao buscar patrimônio: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showErrorSnackBar('Erro ao se conectar ao servidor: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Patrimônios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Digite o ID do patrimônio',
                border: OutlineInputBorder(),
              ),
              onChanged: filterPatrimonio,
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: foundPatrimonio == null
                        ? Center(child: Text('Nenhum patrimônio encontrado.'))
                        : ListTile(
                            title: Text('Nome: ${foundPatrimonio!.nome}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    patrimonio: foundPatrimonio!,
                                    user: widget.user,
                                    patrimonios: widget.patrimonios,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
