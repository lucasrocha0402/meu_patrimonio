import 'package:flutter/material.dart';
import '../models/patrimonio.dart';

class AddPatrimonioScreen extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void adicionarPatrimonio(BuildContext context) {
    final String nome = nomeController.text;
    final double? valor = double.tryParse(valorController.text);

    if (nome.isNotEmpty && valor != null) {
      // Lógica para adicionar patrimônio
      Navigator.of(context).pop(); // Voltar para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Patrimônio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => adicionarPatrimonio(context),
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
