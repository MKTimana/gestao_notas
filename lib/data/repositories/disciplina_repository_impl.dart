import 'package:gestao_notas/data/datasources/json_local_datasource.dart';
import 'package:gestao_notas/domain/exceptions/app_exceptions.dart';
import 'package:gestao_notas/domain/repositories/disciplina_repository.dart';

import '../../domain/entities/disciplina.dart';

class DisciplinaRepositoryImpl implements DisciplinaRepository {
  final JsonLocalDatasource _datasource;
  static const String _coleccao = 'disciplinas';

  const DisciplinaRepositoryImpl(this._datasource);

  @override
  Future<List<Disciplina>> listarDisciplinas() async {
    final maps = await _datasource.lerTodos(_coleccao);
    return maps.map((json) => Disciplina.fromJson(json)).toList();
  }

  @override
  Future<Disciplina?> pesquisarDisciplina(String id) async {
    final todas = await listarDisciplinas();
    try {
      return todas.firstWhere((d) => d.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> guardarDisciplina(Disciplina d) async {
    if (d.nome.trim().isEmpty) throw ValidacaoException('nome');
    if (d.codigo.trim().isEmpty) throw ValidacaoException('codigo');

    final todas = await listarDisciplinas();
    todas.add(d);
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((d) => d.toJson()).toList(),
    );
  }

  @override
  Future<void> actualizarDisciplina(Disciplina d) async {
    final todas = await listarDisciplinas();
    final index = todas.indexWhere((i) => i.id == d.id);
    if (index == -1) throw DisciplinaNaoEncontradaException(d.id);
    todas[index] = d;
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((d) => d.toJson()).toList(),
    );
  }

  @override
  Future<void> removerDisciplina(String id) async {
    final todas = await listarDisciplinas();
    final antes = todas.length;
    todas.removeWhere((d) => d.id == id);
    if (todas.length == antes) throw DisciplinaNaoEncontradaException(id);
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((d) => d.toJson()).toList(),
    );
  }
}
