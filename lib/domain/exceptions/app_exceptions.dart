class AppExceptions implements Exception {
  final String msg;
  final String? codigo;

  AppExceptions({required this.msg, this.codigo});

  @override
  String toString() =>
      'AppException: $msg ${codigo != null ? "[$codigo]" : ""}';
}

class EstudanteNaoEncontradoException extends AppExceptions{
  EstudanteNaoEncontradoException(String id) : super(msg: 'Estudante com ID "$id" não foi encontrado.', codigo: 'ESTUDANTE_NAO_ENCONTRADO');
}

class DisciplinaNaoEncontradaException extends AppExceptions{
  DisciplinaNaoEncontradaException(String id): super(msg: 'A disciplina com ID "$id" nao foi encontrada.', codigo: 'DISCIPLINA_NAO_ENCONTRADA');
}

class PersistenciaException extends AppExceptions{
  PersistenciaException(String detalhe) : super(msg: 'Erro ao salvar ou carregar dados: $detalhe', codigo: 'ERRO_PERSISTENCIA');
}

class ValidacaoException extends AppExceptions{
  ValidacaoException(String campo) : super(msg: 'O campo $campo é invalido ou obrigatório.', codigo: 'ERRO_VALIDACAO');
}