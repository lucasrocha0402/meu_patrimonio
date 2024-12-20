import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../models/patrimonio.dart';
import 'ProductDetailScreen.dart';
import '../services/api_barcode_service.dart'; 

class BarcodeScannerScreen extends StatefulWidget {
  final dynamic user;
  final List<Patrimonio> patrimonios;

  BarcodeScannerScreen({required this.user, required this.patrimonios});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraVisible = true;
  String _productId = '';
  final ApiService _apiService =
      ApiService('https://apiconecta.izzyway.com.br/api');

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isCameraVisible
              ? FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Digite o número do produto',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _productId = value; 
                        });
                      },
                      onSubmitted: (value) {
                        _searchProduct(value, context); 
                      },
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      String? barcode = await _scanBarcode();
                      if (barcode != null) {
                        _searchProduct(
                            barcode, context); 
                      }
                    },
                    icon: Icon(Icons.qr_code, size: 30),
                    label: Text('Escanear', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor:
                          _isCameraVisible ? Colors.purple : Colors.white,
                      foregroundColor:
                          _isCameraVisible ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isCameraVisible =
                            false; 
                      });
                      _searchProduct(_productId, context); 
                    },
                    icon: Icon(Icons.search, size: 30),
                    label: Text('Pesquisar', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor:
                          !_isCameraVisible ? Colors.purple : Colors.white,
                      foregroundColor:
                          !_isCameraVisible ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        return result.rawContent;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Código de barras vazio.')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao escanear: $e')),
      );
      return null;
    }
  }

  Future<void> _searchProduct(String? productId, BuildContext context) async {
    if (productId == null || productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID do produto inválido.')),
      );
      return;
    }

    try {
      Patrimonio? product = await _apiService.getPatrimonioByCodigo(
        productId,
        widget.user.token,
      );

      if (product != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              user: widget.user,
              patrimonio: product,
              patrimonios: widget.patrimonios,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto não encontrado.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
