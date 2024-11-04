import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User_Profile.dart';

class UserService {
  final String baseUrl = 'https://apiconecta.izzyway.com.br/api/Usuario';

  Future<UserProfileData?> fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/GetInformacoes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['result'];
      return UserProfileData.fromJson(
          data); // Criando a instância de UserProfile
    } else {
      print('Erro: ${response.statusCode}');
      return null;
    }
  }
}
