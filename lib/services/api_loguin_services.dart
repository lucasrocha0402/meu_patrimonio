// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String> login(String email, String senha) async {
    final String url = 'https://apiconecta.izzyway.com.br/api/Autentication';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final String token = data['result'];
        await storage.write(key: 'jwt_token', value: token);
        return token; // Agora o retorno é permitido
      } else {
        throw Exception(data['message'] ?? 'Email ou senha incorretos.');
      }
    } else {
      throw Exception('Erro na autenticação: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final String url =
        'https://apiconecta.izzyway.com.br/api/Usuario/GetInformacoes';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erro ao obter informações do usuário: ${response.reasonPhrase}');
    }
  }
}
