class Patrimonio {
  final String id;
  final String nome;
  final double valor;
  final List<String> fotos; // Adiciona a lista de fotos

  Patrimonio({
    required this.id,
    required this.nome,
    required this.valor,
    this.fotos =
        const [], // Inicializa como uma lista vazia se não houver fotos
  });

  @override
  String toString() {
    return 'Patrimonio{id: $id, nome: $nome, valor: $valor, fotos: $fotos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patrimonio &&
        other.id == id &&
        other.nome == nome &&
        other.valor == valor &&
        other.fotos == fotos; // Compara as fotos
  }

  @override
  int get hashCode =>
      id.hashCode ^ nome.hashCode ^ valor.hashCode ^ fotos.hashCode;

  String get formattedValor {
    return 'R\$ ${valor.toStringAsFixed(2)}';
  }
}
