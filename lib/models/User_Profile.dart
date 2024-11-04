class UserProfileData {
  final String nome;
  final String cpf;
  final String nascimentoFormatado;
  final String admissaoFormatado;

  UserProfileData({
    required this.nome,
    required this.cpf,
    required this.nascimentoFormatado,
    required this.admissaoFormatado,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      nome: json['nome'],
      cpf: json['cpf'],
      nascimentoFormatado: json['nascimentoFormatado'],
      admissaoFormatado: json['admissaoFormatado'],
    );
  }
}
