import '../../domain/entities/inscricao.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/inscricao_repository.dart';
import '../datasources/json_local_datasource.dart';

class InscricaoRepositoryImpl implements InscricaoRepository {
  final JsonLocalDatasource _datasource;
  static const String _coleccao = 'inscricoes';

  const InscricaoRepositoryImpl(this._datasource);

  @override
  Future<List<Inscricao>> listarInscricoes() async {
    final maps = await _datasource.lerTodos(_coleccao);
    return maps.map((json) => Inscricao.fromJson(json)).toList();
  }

  @override
  Future<List<Inscricao>> listarPorDisciplina(String disciplinaId) async {
    final todas = await listarInscricoes();

    return todas
        .where((inscricao) => inscricao.disciplinaId == disciplinaId)
        .toList();
  }

  @override
  Future<List<Inscricao>> listarPorEstudante(String estudanteId) async {
    final todas = await listarInscricoes();

    return todas
        .where((inscricao) => inscricao.estudanteId == estudanteId)
        .toList();
  }

  @override
  Future<bool> estudanteEstaInscrito({
    required String estudanteId,
    required String disciplinaId,
  }) async {
    final todas = await listarInscricoes();

    return todas.any(
      (inscricao) =>
          inscricao.estudanteId == estudanteId &&
          inscricao.disciplinaId == disciplinaId,
    );
  }

  @override
  Future<void> guardarInscricao(Inscricao inscricao) async {
    final todas = await listarInscricoes();

    final jaExiste = todas.any(
      (i) =>
          i.estudanteId == inscricao.estudanteId &&
          i.disciplinaId == inscricao.disciplinaId,
    );

    if (jaExiste) {
      throw AppExceptions(
        msg: 'Este estudante já está inscrito nesta disciplina.',
        codigo: 'INSCRICAO_DUPLICADA',
      );
    }

    todas.add(inscricao);

    await _datasource.guardarTodos(
      _coleccao,
      todas.map((i) => i.toJson()).toList(),
    );
  }

  @override
  Future<void> removerInscricao(String id) async {
    final todas = await listarInscricoes();

    final antes = todas.length;
    todas.removeWhere((inscricao) => inscricao.id == id);

    if (todas.length == antes) {
      throw AppExceptions(
        msg: 'Inscrição com ID "$id" não encontrada.',
        codigo: 'INSCRICAO_NAO_ENCONTRADA',
      );
    }

    await _datasource.guardarTodos(
      _coleccao,
      todas.map((i) => i.toJson()).toList(),
    );
  }
}