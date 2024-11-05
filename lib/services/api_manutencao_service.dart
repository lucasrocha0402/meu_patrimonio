import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ManutencaoService {
  final String _url =
      'https://apiconecta.izzyway.com.br/api/Patrimonio/CriaManutencao';

  // Método para enviar manutenção
  Future<bool> enviarManutencao(String motivo, List<XFile> fotos) async {
    try {
      // Criação do multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_url));

      // Adiciona o motivo da manutenção
      request.fields['motivo'] = motivo;

      // Adiciona as fotos
      for (var foto in fotos) {
        var fotoFile = await http.MultipartFile.fromPath('foto', foto.path);
        request.files.add(fotoFile);
      }

      // Envia a requisição e aguarda a resposta
      var response = await request.send();

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
}
