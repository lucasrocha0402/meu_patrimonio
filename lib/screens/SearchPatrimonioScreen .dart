import 'package:flutter/material.dart';
import '../models/patrimonio.dart';
import 'ProductDetailScreen .dart';

class SearchPatrimonioScreen extends StatefulWidget {
  final List<Patrimonio> patrimonioList;

  SearchPatrimonioScreen({required this.patrimonioList});

  @override
  _SearchPatrimonioScreenState createState() => _SearchPatrimonioScreenState();
}

class _SearchPatrimonioScreenState extends State<SearchPatrimonioScreen> {
  List<Patrimonio> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = widget.patrimonioList; // Inicializa com a lista completa
  }

  void filterPatrimonio(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = widget.patrimonioList;
      } else {
        filteredList = widget.patrimonioList.where((patrimonio) {
          return patrimonio.id.toString().contains(query);
        }).toList();
      }
    });
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
            Expanded(
              child: filteredList.isEmpty
                  ? Center(child: Text('Nenhum patrimônio encontrado.'))
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'ID: ${filteredList[index].id} - ${filteredList[index].nome}',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  patrimonio: filteredList[index],
                                ),
                              ),
                            );
                          },
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
