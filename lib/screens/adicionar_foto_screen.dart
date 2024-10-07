import 'dart:io'; // Importar para trabalhar com arquivos
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'manutencao_screen.dart'; // ajuste o caminho
import '../models/patrimonio.dart';

class AdicionarFotoScreen extends StatefulWidget {
  final String patrimonioId; // ID do patrimônio

  AdicionarFotoScreen({required this.patrimonioId});

  @override
  _AdicionarFotoScreenState createState() => _AdicionarFotoScreenState();
}

class _AdicionarFotoScreenState extends State<AdicionarFotoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _foto; // Variável para armazenar a foto capturada

  Future<void> _adicionarFoto() async {
    try {
      final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
      if (foto != null) {
        setState(() {
          _foto = foto; // Armazena a foto capturada
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao capturar a foto: $e')),
      );
    }
  }

  void _navegarParaManutencao(BuildContext context) {
    if (_foto != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManutencaoScreen(
            patrimonio: Patrimonio(
                id: widget.patrimonioId,
                nome: '',
                valor: 0), // Ajuste conforme necessário
            // Para a tela de manutenção, ajuste o patrimônio conforme sua lógica
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma foto tirada.')),
      );
    }
  }

  void _excluirFoto() {
    setState(() {
      _foto = null; // Remove a foto
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto excluída com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_foto != null) ...[
              GestureDetector(
                onTap: () {
                  // Exibe a foto em um diálogo ao ser clicada
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          child: Image.file(File(_foto!.path)),
                        ),
                      );
                    },
                  );
                },
                child:
                    Image.file(File(_foto!.path), height: 200), // Mostra a foto
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _excluirFoto,
                child: Text('Excluir Foto'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarFoto,
              child: Text('Tirar Foto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navegarParaManutencao(context),
              child: Text('Ir para Manutenção'),
            ),
          ],
        ),
      ),
    );
  }
}
