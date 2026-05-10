import '../entities/inscricao.dart';

abstract interface class InscricaoRepository {
  Future<List<Inscricao>> listarInscricoes();
  Future<List<Inscricao>> listarPorDisciplina(String disciplinaId);
  Future<List<Inscricao>> listarPorEstudante(String estudanteId);

  Future<bool> estudanteEstaInscrito({
    required String estudanteId,
    required String disciplinaId,
  });

  Future<void> guardarInscricao(Inscricao inscricao);
  Future<void> removerInscricao(String id);
}