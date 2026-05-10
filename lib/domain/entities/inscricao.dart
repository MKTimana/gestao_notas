class Inscricao {
  final String id;
  final String estudanteId;
  final String disciplinaId;
  final DateTime dataInscricao;

  const Inscricao({
    required this.id,
    required this.estudanteId,
    required this.disciplinaId,
    required this.dataInscricao,
  });

  Inscricao copyWith({
    String? id,
    String? estudanteId,
    String? disciplinaId,
    DateTime? dataInscricao,
  }) {
    return Inscricao(
      id: id ?? this.id,
      estudanteId: estudanteId ?? this.estudanteId,
      disciplinaId: disciplinaId ?? this.disciplinaId,
      dataInscricao: dataInscricao ?? this.dataInscricao,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estudanteId': estudanteId,
      'disciplinaId': disciplinaId,
      'dataInscricao': dataInscricao.toIso8601String(),
    };
  }

  factory Inscricao.fromJson(Map<String, dynamic> json) {
    return Inscricao(
      id: json['id'] as String,
      estudanteId: json['estudanteId'] as String,
      disciplinaId: json['disciplinaId'] as String,
      dataInscricao: DateTime.parse(json['dataInscricao'] as String),
    );
  }
}