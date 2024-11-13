import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/patrimonio.dart'; // Importe a classe Patrimonio
import 'api_loguin_services.dart'; // Importa o serviço ApiService para obter o token

class ManutencaoService {
  final String _url =
      'https://apiconecta.izzyway.com.br/api/Patrimonio/CriaManutencao';

  final ApiService apiService = ApiService();

  // Método para enviar manutenção
  Future<bool> enviarManutencao(
      Patrimonio patrimonio, String motivo, List<XFile> fotos) async {
    try {
      // Recuperando o token armazenado
      final String? token = await apiService.getStoredToken();

      if (token == null) {
        print('Erro: Token não encontrado.');
        return false;
      }

      // Lista para armazenar os anexos no formato esperado pela API
      List<Map<String, String>> anexos = [];

      // Converte as fotos para Base64
      for (var foto in fotos) {
        String fotoBase64 =
            await _converterImagemParaBase64(foto); // Converte cada foto
        anexos.add({
          "imagem": fotoBase64, // Adiciona a foto convertida em Base64
        });
      }

      // Criação do corpo da requisição com a estrutura correta
      Map<String, dynamic> corpoRequisicao = {
        "bemId": patrimonio.codigo, // Usa o código como bemId
        "anexos": anexos, // Lista de anexos com as imagens em Base64
      };

      // Se o motivo for fornecido, podemos adicionar ao corpo da requisição
      if (motivo.isNotEmpty) {
        corpoRequisicao["motivo"] = motivo;
      }

      // Envia a requisição para a API com o token no cabeçalho
      var response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token', // Passando o token na requisição
          'Content-Type': 'application/json',
        },
        body: jsonEncode(corpoRequisicao),
      );

      // Verifica se o envio foi bem-sucedido (status code 200)
      if (response.statusCode == 200) {
        print('Manutenção enviada com sucesso!');
        return true;
      } else {
        print('Erro ao enviar manutenção: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao enviar manutenção: $e');
      return false;
    }
  }

  // Função para converter a imagem para Base64
  Future<String> _converterImagemParaBase64(XFile foto) async {
    final bytes = await File(foto.path).readAsBytes(); // Lê os bytes da imagem
    return base64Encode(bytes); // Converte os bytes para uma string Base64
  }
}
