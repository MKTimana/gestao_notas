import 'package:gestao_notas/domain/entities/disciplina.dart';

abstract interface class DisciplinaRepository {
  Future<List<Disciplina>> listarDisciplinas();
  Future<Disciplina?> pesquisarDisciplina();
  Future<void> guardarDisciplina(Disciplina d);
  Future<void> actualizarDisciplina(Disciplina d);
  Future<void> removerDisciplina(String id);
}
