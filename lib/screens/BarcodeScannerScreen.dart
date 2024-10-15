import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../models/patrimonio.dart';
import 'ProductDetailScreen.dart';

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
  int _currentIndex = 1; // Índice inicial correspondente ao BarcodeScanner
  bool _isCameraVisible = true;

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
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(
          child: Text(
            'Conecta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
                      onSubmitted: (value) {
                        _searchProduct(value, context);
                      },
                    ),
                  ),
                ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCameraVisible = true;
                    });
                  },
                  icon: Icon(Icons.qr_code, size: 30),
                  label: Text('Escanear', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                      _isCameraVisible = false;
                    });
                  },
                  icon: Icon(Icons.search, size: 30),
                  label: Text('Pesquisar', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor:
                        !_isCameraVisible ? Colors.purple : Colors.white,
                    foregroundColor:
                        !_isCameraVisible ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 50), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code, size: 50), label: 'Escanear'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 50), label: 'Perfil'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        onTap: (index) => _onBottomNavTap(index, context),
      ),
    );
  }

  void _searchProduct(String productId, BuildContext context) {
    final Patrimonio notFoundProduct = Patrimonio(
      id: '',
      nome: 'Produto não encontrado',
      serie: 0,
      categoria: '',
      marca: '',
      garantia: '',
      colaborador: '',
    );

    final Patrimonio product = widget.patrimonios.firstWhere(
      (p) => p.id == productId,
      orElse: () => notFoundProduct,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(product.nome)),
    );

    if (product.id.isNotEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          patrimonio: product,
          user: widget.user,
          patrimonios: widget.patrimonios,
        ),
      ));
    }
  }

  void _onBottomNavTap(int index, BuildContext context) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: widget.user)),
          );
          break;
        case 1:
          // Permanece na tela de BarcodeScanner
          break;
        case 2:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userName: widget.user.nome,
                user: widget.user,
                patrimonio: widget.patrimonios,
              ),
            ),
          );
          break;
      }
    }
  }
}
