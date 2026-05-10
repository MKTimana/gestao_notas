class Disciplina {
  final String id;
  final String nome;
  final String codigo;
  final int cargaHoraria;
  final String? descricao;

  const Disciplina({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.cargaHoraria,
    this.descricao,
  });

  Disciplina copyWith({
    String? id,
    String? nome,
    String? codigo,
    int? cargaHoraria,
    String? descricao,
  }) {
    return Disciplina(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Disciplina && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
