import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patrimonio.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Patrimonio?> getPatrimonioByCodigo(String codigo, String token) async {
    final String url = '$baseUrl/Patrimonio/GetBemPorCodigo?codigo=$codigo';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['result'];
        if (data != null) {
          return Patrimonio(
            codigo: data['codigo'] ?? '',
            nome: data['nome'] ?? 'Nome desconhecido',
            serie: data['serie'],
            categoria: data['categoria'],
            marca: data['marca'] ?? 'Marca desconhecida',
            garantia: data['garantia'],
            localizacao: data['localizacao'] ?? 0,
            status: data['status'] ?? 0,
            ambiente: data['ambiente'],
            pessoa: data['pessoa'],
            colaborador: data['colaborador'],
            fotos: List<String>.from(data['fotos'] ?? []),
          );
        }
      } else {
        throw Exception('Erro ao buscar produto: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erro ao se conectar ao servidor: $e');
    }
    return null;
  }
}
