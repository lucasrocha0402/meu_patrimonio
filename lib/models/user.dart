class User {
  final int id;
  final String nome;
  final String email;
  final String password;

  User(
      {required this.id,
      required this.nome,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      password: json['password'],
    );
  }
}
