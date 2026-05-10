import 'package:gestao_notas/data/datasources/json_local_datasource.dart';
import 'package:gestao_notas/domain/entities/estudante.dart';
import 'package:gestao_notas/domain/exceptions/app_exceptions.dart';
import 'package:gestao_notas/domain/repositories/estudante_repository.dart';

class EstudanteRepositoryImpl implements EstudanteRepository {
  final JsonLocalDatasource _datasource;
  static const String _coleccao = 'estudantes';

  const EstudanteRepositoryImpl(this._datasource);

  @override
  Future<void> actualizarEstudante(Estudante estudante) async {
    final todos = await listarEstudantes();

    final index = todos.indexWhere((e) => e.id == estudante.id);

    if (index == -1) {
      throw EstudanteNaoEncontradoException(estudante.id);
    }

    todos[index] = estudante;

    await _datasource.guardarTodos(
      _coleccao,
      todos.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<void> guardarEstudante(Estudante estudante) async {
    if (estudante.nome.trim().isEmpty) {
      throw ValidacaoException('nome');
    }
    if (estudante.numero.trim().isEmpty) {
      throw ValidacaoException('numero');
    }

    final todos = await listarEstudantes();

    final duplicado = todos.any(
      (e) => e.numero == estudante.numero && e.id != estudante.id,
    );

    if (duplicado) {
      throw AppExceptions(
        msg: 'Já existe um estudante com este número.',
        codigo: 'NUMERO_DUPLICADO',
      );
    }

    todos.add(estudante);

    await _datasource.guardarTodos(
      _coleccao,
      todos.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<Estudante>> listarEstudantes() async {
    final listaMaps = await _datasource.lerTodos(_coleccao);

    return listaMaps.map((json) => Estudante.fromJson(json)).toList();
  }

  @override
  Future<Estudante?> procurarEstudante(String id) async {
    final todos = await listarEstudantes();

    try {
      return todos.firstWhere((e) => e.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> removerEstudante(String id) async {
    final todos = await listarEstudantes();
    final tamanhoAntes = todos.length;
    todos.removeWhere((e) => e.id == id);

    if (todos.length == tamanhoAntes) {
      throw EstudanteNaoEncontradoException(id);
    }

    await _datasource.guardarTodos(
      _coleccao,
      todos.map((e) => e.toJson()).toList(),
    );
  }
}
