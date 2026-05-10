import 'package:gestao_notas/domain/entities/estudante.dart';

abstract interface class EstudanteRepository {
  Future<List<Estudante>> listarEstudantes();
  Future<Estudante?> procurarEstudante(String id);
  Future<void> guardarEstudante(Estudante estudante);
  Future<void> actualizarEstudante(Estudante estudante);
  Future<void> removerEstudante(String id);
}
