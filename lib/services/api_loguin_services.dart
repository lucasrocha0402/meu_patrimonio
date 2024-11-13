import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Função para fazer login e armazenar o token
  Future<String> login(String email, String senha) async {
    final String url = 'https://apiconecta.izzyway.com.br/api/Autentication';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Verificando se o campo 'success' é verdadeiro e que 'result' contém o token
      if (data['success'] == true && data['result'] != null) {
        final String token = data['result'];

        // Armazenando o token de forma segura
        await storage.write(key: 'jwt_token', value: token);

        print('Token armazenado com sucesso: $token'); // Log para verificar

        return token; // Retorna o token para uso imediato
      } else {
        throw Exception(data['message'] ?? 'Email ou senha incorretos.');
      }
    } else {
      throw Exception('Erro na autenticação: ${response.reasonPhrase}');
    }
  }

  // Função para recuperar o token armazenado
  Future<String?> getStoredToken() async {
    // Recupera o token armazenado no Flutter Secure Storage
    return await storage.read(key: 'jwt_token');
  }

  // Função para obter informações do usuário com o token armazenado
  Future<Map<String, dynamic>> getUserInfo() async {
    // Recuperando o token armazenado
    final String? token = await getStoredToken();

    // Verificando se o token está disponível
    if (token == null) {
      throw Exception(
          'Token não encontrado. O usuário pode não estar autenticado.');
    }

    final String url =
        'https://apiconecta.izzyway.com.br/api/Usuario/GetInformacoes';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $token', // Incluindo o token no cabeçalho de autorização
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna os dados do usuário
    } else {
      throw Exception(
          'Erro ao obter informações do usuário: ${response.reasonPhrase}');
    }
  }
}
