import 'package:gestao_notas/domain/exceptions/app_exceptions.dart';
import '../../domain/entities/avaliacao.dart';
import '../../domain/repositories/avaliacao_repository.dart';
import '../datasources/json_local_datasource.dart';

class AvaliacaoRepositoryImpl implements AvaliacaoRepository {
  final JsonLocalDatasource _datasource;
  static const String _coleccao = 'avaliacoes';

  const AvaliacaoRepositoryImpl(this._datasource);

  @override
  Future<List<Avaliacao>> listarAvaliacao() async {
    final maps = await _datasource.lerTodos(_coleccao);
    return maps.map((json) => Avaliacao.fromJson(json)).toList();
  }

  @override
  Future<List<Avaliacao>> listarPorDisciplina(String disciplinaId) async {
    final todas = await listarAvaliacao();
    return todas.where((a) => a.disciplinaId == disciplinaId).toList();
  }

  @override
  Future<List<Avaliacao>> listarPorEstudante(String estudanteId) async {
    final todas = await listarAvaliacao();
    return todas.where((a) => a.estudanteId == estudanteId).toList();
  }

  @override
  Future<double?> calcularMedia(String estudanteId, String disciplinaId) async {
    final todas = await listarAvaliacao();

    final comNota = todas
        .where(
          (a) =>
              a.estudanteId == estudanteId &&
              a.disciplinaId == disciplinaId &&
              a.temNota,
        )
        .toList();

    if (comNota.isEmpty) return null;

    final somaPercentagens = comNota.fold<double>(
      0.0,
      (soma, avaliacao) => soma + avaliacao.percentagem,
    );

    return somaPercentagens / comNota.length;
  }

  @override
  Future<void> guardarAvaliacao(Avaliacao avaliacao) async {
    final todas = await listarAvaliacao();
    todas.add(avaliacao);
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((a) => a.toJson()).toList(),
    );
  }

  @override
  Future<void> actualizarAvaliacao(Avaliacao avaliacao) async {
    final todas = await listarAvaliacao();
    final index = todas.indexWhere((a) => a.id == avaliacao.id);
    if (index == -1) {
      throw AppExceptions(
        msg: 'Avaliação com ID "${avaliacao.id}" não encontrada.',
        codigo: 'AVALIACAO_NAO_ENCONTRADA',
      );
    }
    todas[index] = avaliacao;
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((a) => a.toJson()).toList(),
    );
  }

  @override
  Future<void> removerAvaliacao(String id) async {
    final todas = await listarAvaliacao();
    final antes = todas.length;
    todas.removeWhere((a) => a.id == id);
    if (todas.length == antes) {
      throw AppExceptions(
        msg: 'Avaliação com ID "$id" não encontrada.',
        codigo: 'AVALIACAO_NAO_ENCONTRADA',
      );
    }
    await _datasource.guardarTodos(
      _coleccao,
      todas.map((a) => a.toJson()).toList(),
    );
  }
}
