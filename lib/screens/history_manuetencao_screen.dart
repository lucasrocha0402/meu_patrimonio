import 'package:flutter/material.dart';
import '../models/patrimonio.dart';

class HistoryManutencaoScreen extends StatelessWidget {
  final Patrimonio patrimonio;

  HistoryManutencaoScreen({required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    // Aqui você pode preencher a lógica para exibir as manutenções
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Manutenções - ID: ${patrimonio.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patrimônio: ${patrimonio.nome}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Valor: R\$ ${patrimonio.valor.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Aqui você pode adicionar a lista de manutenções
            Expanded(
              child: ListView(
                // Adicione suas manutenções aqui
                children: [
                  ListTile(title: Text('Manutenção 1')),
                  ListTile(title: Text('Manutenção 2')),
                  ListTile(title: Text('Manutenção 3')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
