class Patrimonio {
  final String id;
  final String nome;
  final double serie;
  final String categoria;
  final String marca;
  final String garantia;
  final String colaborador;
  final List<String> fotos;

  Patrimonio({
    required this.id,
    required this.nome,
    required this.serie,
    required this.categoria,
    required this.marca,
    required this.garantia,
    required this.colaborador,
    this.fotos = const [],
  });

  @override
  String toString() {
    return 'Patrimonio{id: $id, nome: $nome, serie: $serie, categoria: $categoria, marca: $marca, garantia: $garantia, colaborador: $colaborador, fotos: $fotos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patrimonio &&
        other.id == id &&
        other.nome == nome &&
        other.serie == serie &&
        other.categoria == categoria &&
        other.marca == marca &&
        other.garantia == garantia &&
        other.colaborador == colaborador &&
        other.fotos == fotos; // Compara as fotos
  }

  @override
  int get hashCode =>
      id.hashCode ^
      nome.hashCode ^
      serie.hashCode ^
      categoria.hashCode ^
      marca.hashCode ^
      garantia.hashCode ^
      colaborador.hashCode ^
      fotos.hashCode;
}
