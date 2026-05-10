enum TipoAvaliacao { teste, exame, trabalho, quiz }

class Avaliacao {
  final String id;
  final String disciplinaId;
  final String estudanteId;
  final TipoAvaliacao tipo;
  final double? nota;
  final double notaMaxima;
  final DateTime data;

  const Avaliacao({
    required this.id,
    required this.disciplinaId,
    required this.estudanteId,
    required this.tipo,
    this.nota,
    required this.notaMaxima,
    required this.data,
  });

  bool get temNota => nota != null;
  double get percentagem {
    if (nota == null) return 0.0;
    return (nota! / notaMaxima) * 100;
  }

  String get classificacao {
    {
      if (!temNota) return 'Por avaliar';
      final p = percentagem;
      if (p >= 90) return 'Excelente desempenho';
      if (p >= 75) return 'Bom desempenho';
      if (p >= 60) return 'Suficiente desempenho';
      return 'Desempenho insuficiente';
    }
  }

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'] as String,
      disciplinaId: json['disciplinaId'] as String,
      estudanteId: json['estudanteId'] as String,
      tipo: TipoAvaliacao.values.byName(json['tipo'] as String),
      nota: json['nota'] == null ? null : (json['nota'] as num).toDouble(),
      notaMaxima: (json['notaMaxima'] as num).toDouble(),
      data: DateTime.parse(json['data'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disciplinaId': disciplinaId,
      'estudanteId': estudanteId,
      'tipo': tipo.name,
      'nota': nota,
      'notaMaxima': notaMaxima,
      'data': data.toIso8601String(),
    };
  }

  Avaliacao copyWith({
    String? id,
    String? disciplinaId,
    String? estudanteId,
    TipoAvaliacao? tipo,
    double? nota,
    double? notaMaxima,
    DateTime? data,
  }) {
    return Avaliacao(
      id: id ?? this.id,
      disciplinaId: disciplinaId ?? this.disciplinaId,
      estudanteId: estudanteId ?? this.estudanteId,
      tipo: tipo ?? this.tipo,
      nota: nota ?? this.nota,
      notaMaxima: notaMaxima ?? this.notaMaxima,
      data: data ?? this.data,
    );
  }
}
