import 'package:flutter/material.dart';

class FotosScreen extends StatelessWidget {
  final List<String> fotos;

  FotosScreen({required this.fotos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos do Patrimônio'),
      ),
      body: fotos.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: fotos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    fotos[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          : Center(child: Text('Nenhuma foto disponível')),
    );
  }
}
