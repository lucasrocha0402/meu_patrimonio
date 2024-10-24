import 'package:flutter/material.dart';
import 'package:patrimonio_izzy_app/models/user.dart';
import 'package:patrimonio_izzy_app/screens/home_screen.dart';
import '../models/patrimonio.dart';
import 'manutencao_screen.dart';
import 'adicionar_foto_screen.dart';

class FotosScreen extends StatefulWidget {
  final List<String> fotos;
  final Patrimonio patrimonio;
  final User user;
  final List<Patrimonio> patrimonios;

  FotosScreen({
    required this.fotos,
    required this.patrimonio,
    required this.user,
    required this.patrimonios,
  });

  @override
  _FotosScreenState createState() => _FotosScreenState();
}

class _FotosScreenState extends State<FotosScreen> {
  late List<String> todasAsFotos;

  @override
  void initState() {
    super.initState();
    todasAsFotos = List.from(widget.fotos);
  }

  void _navigateToAdicionarFoto() async {
    final novasFotos = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarFotoScreen(),
      ),
    );

    if (novasFotos != null) {
      setState(() {
        todasAsFotos
            .addAll(novasFotos); // Adiciona a nova foto à lista existente
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 209, 168),
        title: Text(
          'Fotos do Patrimônio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: widget.user,
                  token: '',
                ),
              ),
              (route) => false, // Remove todas as rotas anteriores
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'adicionar_foto') {
                  _navigateToAdicionarFoto();
                } else if (value == 'manutencao') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManutencaoScreen(
                        patrimonio: widget.patrimonio,
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'adicionar_foto',
                      child: Text('Adicionar Foto'),
                    ),
                    PopupMenuItem<String>(
                      value: 'manutencao',
                      child: Text('Manutenção'),
                    ),
                  ]),
        ],
      ),
      body: todasAsFotos.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: todasAsFotos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FotoDetalheScreen(
                            url: todasAsFotos[index],
                            patrimonio: widget.patrimonio,
                            user: widget.user,
                            patrimonios: widget.patrimonios,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'foto_$index',
                      child: Image.network(
                        todasAsFotos[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.error));
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('Nenhuma foto disponível')),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.info, size: 50), label: 'Dados'),
        BottomNavigationBarItem(
            icon: Icon(Icons.photo_library, size: 50), label: 'Fotos'),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: widget.user,
                token: '',
              ),
            ),
          );
        }
      },
    );
  }
}

class FotoDetalheScreen extends StatelessWidget {
  final String url;
  final Patrimonio patrimonio;
  final User user;
  final List<Patrimonio> patrimonios;

  FotoDetalheScreen({
    required this.url,
    required this.patrimonio,
    required this.user,
    required this.patrimonios,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(
          'Detalhe da Foto',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'foto_${url.hashCode}',
          child: Image.network(
            url,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Icon(Icons.error));
            },
          ),
        ),
      ),
    );
  }
}
