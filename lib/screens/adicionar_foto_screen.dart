import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdicionarFotoScreen extends StatefulWidget {
  @override
  _AdicionarFotoScreenState createState() => _AdicionarFotoScreenState();
}

class _AdicionarFotoScreenState extends State<AdicionarFotoScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRearCamera = true;
  XFile? _foto;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[_isRearCamera ? 0 : 1],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
      // Chama setState apenas após a inicialização
      setState(() {});
    } catch (e) {
      print('Erro ao inicializar a câmera: $e');
      // Tratar erro aqui (ex: mostrar um Snackbar)
    }
  }

  Future<void> _tirarFoto() async {
    await _initializeControllerFuture; // Garante que a câmera está inicializada
    try {
      _foto = await _controller!.takePicture();
      setState(() {});
    } catch (e) {
      print('Erro ao tirar foto: $e');
    }
  }

  void _alternarCamera() {
    setState(() {
      _isRearCamera = !_isRearCamera;
      _initializeCamera(); // Reinicializa a câmera ao alternar
    });
  }

  void _enviarFoto() {
    if (_foto != null) {
      Navigator.pop(context, [_foto!.path]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma foto tirada para enviar.')),
      );
    }
  }

  void _excluirFoto() {
    setState(() {
      _foto = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Foto excluída com sucesso!')),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          'Adicionar Foto',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_ios),
            onPressed: _alternarCamera,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                if (_foto != null)
                  Image.file(
                    File(_foto!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                else
                  CameraPreview(_controller!),
                Positioned(
                  top: 50,
                  left: MediaQuery.of(context).size.width / 2 - 30,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 70),
                    color: Colors.white,
                    onPressed: _tirarFoto,
                  ),
                ),
                if (_foto != null)
                  Positioned(
                    bottom: 50,
                    left: MediaQuery.of(context).size.width / 2 - 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _enviarFoto,
                          child: Icon(Icons.check, size: 30),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _excluirFoto,
                          child: Icon(Icons.delete, size: 30),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
