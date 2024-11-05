import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:io';
import '../models/patrimonio.dart';
import '../services/api_manutencao_service.dart'; // Importe o serviço

class ManutencaoScreen extends StatefulWidget {
  final Patrimonio patrimonio;

  ManutencaoScreen({required this.patrimonio});

  @override
  _ManutencaoScreenState createState() => _ManutencaoScreenState();
}

class _ManutencaoScreenState extends State<ManutencaoScreen> {
  final TextEditingController _motivoController = TextEditingController();
  final List<XFile> _fotos = [];
  final ImagePicker _picker = ImagePicker();
  final ManutencaoService _manutencaoService =
      ManutencaoService(); // Instância do serviço

  Future<void> _adicionarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      setState(() {
        _fotos.add(foto);
      });
    }
  }

  Future<void> _enviarManutencao() async {
    String motivo = _motivoController.text;

    // Chama o serviço para enviar a manutenção
    bool sucesso = await _manutencaoService.enviarManutencao(motivo, _fotos);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Manutenção enviada com sucesso!')),
      );
      _motivoController.clear();
      setState(() {
        _fotos.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao enviar a manutenção!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 209, 168),
        title: Text(
          'Manutenção do Patrimônio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _enviarManutencao,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patrimônio: ${widget.patrimonio.nome}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Motivo da Manutenção:'),
            TextField(
              controller: _motivoController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descreva o motivo...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarFoto,
              child: Text('Adicionar Foto'),
            ),
            SizedBox(height: 20),
            Text('Fotos Adicionadas:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _fotos.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: _fotos.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewGalleryScreen(
                                    fotos: _fotos,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                File(_fotos[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _fotos.removeAt(
                                      index); // Remove a foto da lista
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Foto excluída!')),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Text('Nenhuma foto adicionada.'),
          ],
        ),
      ),
    );
  }
}

// Classe para visualizar as fotos
class PhotoViewGalleryScreen extends StatelessWidget {
  final List<XFile> fotos;
  final int initialIndex;

  PhotoViewGalleryScreen({required this.fotos, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: fotos.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(fotos[index].path)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
