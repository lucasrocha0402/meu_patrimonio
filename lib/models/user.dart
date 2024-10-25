class User {
  final String email;
  final String password;
  final String token; // Adicione o atributo token

  User(
      {required this.email,
      required this.password,
      required this.token}); // Inclua o token no construtor

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      token: json['token'], // Supondo que o token venha do JSON
    );
  }
}
