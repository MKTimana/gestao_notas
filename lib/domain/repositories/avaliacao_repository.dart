import 'package:gestao_notas/domain/entities/avaliacao.dart';

abstract interface class AvaliacaoRepository {
  Future<List<Avaliacao>> listarAvaliacao();
  Future<List<Avaliacao>> listarPorDisciplina(String disciplinaId);
  Future<List<Avaliacao>> listarPorEstudante(String estudanteId);

  Future<void> guardarAvaliacao(Avaliacao a);
  Future<void> actualizarAvaliacao(Avaliacao a);
  Future<void> removerAvaliacao(String id);

  Future<double?> calcularMedia(String estudanteId, String disciplinaId);
}
