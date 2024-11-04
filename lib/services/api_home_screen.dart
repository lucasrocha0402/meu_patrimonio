import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patrimonio.dart';

class PatrimonioService {
  final String baseUrl;
  final String token;

  PatrimonioService({required this.baseUrl, required this.token});

  Future<List<Patrimonio>> fetchPatrimonios() async {
    final String url = '$baseUrl/api/Patrimonio/GetTodosBemColaborador';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['result'];
        return data.map((item) {
          return Patrimonio(
            nome: item['nome'],
            serie: item['serie'].toDouble(),
            categoria: item['categoria'],
            marca: item['marca'],
            garantia: item['garantia'],
            colaborador: item['colaborador'],
            fotos: List<String>.from(item['fotos'] ?? []),
            codigo: item['codigo'] ?? '',
            localizacao: item['localizacao'] ?? '',
            status: item['status'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Erro ao obter patrimônios: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao se conectar ao servidor: $e');
    }
  }
}
