class Patrimonio {
  final String codigo;
  final String nome;
  final String? serie; // Nullable
  final String? categoria; // Nullable
  final String marca;
  final String? garantia; // Nullable
  final int localizacao;
  final int status;
  final String? ambiente; // Nullable
  final String? pessoa; // Nullable
  final String? colaborador; // Adicionado para compatibilidade
  final List<String> fotos; // Adicionado para compatibilidade

  Patrimonio({
    required this.codigo,
    required this.nome,
    this.serie,
    this.categoria,
    required this.marca,
    this.garantia,
    required this.localizacao,
    required this.status,
    this.ambiente,
    this.pessoa,
    this.colaborador, // Adicionado
    List<String>? fotos, // Adicionado
  }) : fotos = fotos ?? []; // Inicializa como uma lista vazia se for nulo

  @override
  String toString() {
    return 'Patrimonio{codigo: $codigo, nome: $nome, serie: $serie, categoria: $categoria, marca: $marca, garantia: $garantia, localizacao: $localizacao, status: $status, ambiente: $ambiente, pessoa: $pessoa, colaborador: $colaborador, fotos: $fotos}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patrimonio &&
        other.codigo == codigo &&
        other.nome == nome &&
        other.serie == serie &&
        other.categoria == categoria &&
        other.marca == marca &&
        other.garantia == garantia &&
        other.localizacao == localizacao &&
        other.status == status &&
        other.ambiente == ambiente &&
        other.pessoa == pessoa &&
        other.colaborador == colaborador &&
        other.fotos == fotos; // Compara as fotos
  }

  @override
  int get hashCode =>
      codigo.hashCode ^
      nome.hashCode ^
      serie.hashCode ^
      categoria.hashCode ^
      marca.hashCode ^
      garantia.hashCode ^
      localizacao.hashCode ^
      status.hashCode ^
      ambiente.hashCode ^
      pessoa.hashCode ^
      colaborador.hashCode ^
      fotos.hashCode;
}
