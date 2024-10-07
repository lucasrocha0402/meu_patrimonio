import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../models/patrimonio.dart';
import 'ProductDetailScreen.dart'; // Corrigido o espaço no nome do arquivo

class BarcodeScannerScreen extends StatefulWidget {
  final dynamic user; // Ajuste o tipo com base no seu modelo de usuário
  final List<Patrimonio> patrimonios;

  BarcodeScannerScreen({required this.user, required this.patrimonios});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  int _currentIndex = 2; // Defina o índice correspondente a esta tela

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitor de Código de Barras/QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                String result = await scanBarcode(context);
                if (result.isNotEmpty) {
                  _searchProduct(result, context);
                }
              },
              child: Text('Iniciar Leitura'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSearchDialog(context);
              },
              child: Text('Pesquisar Produto'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: 'Manutenções'),
        ],
        currentIndex: _currentIndex, // Define o índice atual
        onTap: (index) {
          _onBottomNavTap(index, context);
        },
      ),
    );
  }

  Future<String> scanBarcode(BuildContext context) async {
    try {
      final result = await BarcodeScanner.scan();
      return result.rawContent;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao ler o código: $e')),
      );
      return '';
    }
  }

  void _showSearchDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pesquisar Produto'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Digite o número do produto'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String productId = controller.text.trim();
                Navigator.of(context)
                    .pop(); // Fechar o diálogo antes de pesquisar
                _searchProduct(productId, context);
              },
              child: Text('Pesquisar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _searchProduct(String productId, BuildContext context) {
    final Patrimonio notFoundProduct =
        Patrimonio(id: '', nome: 'Produto não encontrado', valor: 0);

    final Patrimonio product = widget.patrimonios.firstWhere(
      (p) => p.id == productId,
      orElse: () => notFoundProduct,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(product.nome)),
    );

    if (product.id.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailScreen(patrimonio: product),
      ));
    }
  }

  void _onBottomNavTap(int index, BuildContext context) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user: widget.user)),
          );
          break;
        case 1:
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
