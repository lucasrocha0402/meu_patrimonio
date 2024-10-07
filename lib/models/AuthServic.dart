import 'user.dart';

class AuthService {
  final List<User> _mockedUsers = [
    User(id: 1, nome: 'Lucas', email: 'lucas@gmail.com', password: '123456'),
    User(id: 2, nome: 'Caua', email: 'caua@gmail.com', password: '123456'),
  ];

  User? login(String email, String password) {
    try {
      return _mockedUsers.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null; // Retorna null se não encontrar o usuário
    }
  }
}
