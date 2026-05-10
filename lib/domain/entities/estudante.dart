class Estudante {
  final String id;
  final String nome;
  final String numero;
  final String? email;

  const Estudante({
    required this.id,
    required this.nome,
    required this.numero,
    this.email,
  });

  String get emailOuPadrao => email ?? 'sem.email@isutc.co.mz';

  Estudante copyWith({
    String? id,
    String? nome,
    String? numero,
    String? email,
  }) {
    return Estudante(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numero: numero ?? this.numero,
      email: email ?? this.email,
    );
  }

  @override
  String toString() =>
      'Estudante(id: $id, nome: $nome, numero: $numero, email: $email)';

  @override
  bool operator ==(Object other) => other is Estudante && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
