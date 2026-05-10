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

  factory Estudante.fromJson(Map<String, dynamic> json) {
    return Estudante(
      id: json['id'] as String,
      nome: json['nome'] as String,
      numero: json['numero'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'nome':nome ,
      'numero': numero,
      'email': email,
    };
  }

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
