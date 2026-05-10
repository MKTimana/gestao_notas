import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/disciplina.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/disciplina_repository.dart';
import 'view_state.dart';

class DisciplinaViewModel extends ChangeNotifier {
  final DisciplinaRepository _repository;
  final _uuid = const Uuid();

  DisciplinaViewModel(this._repository);

  List<Disciplina> _disciplinas = [];
  ViewState _state = const ViewState.inicial();

  List<Disciplina> get disciplinas => List.unmodifiable(_disciplinas);
  ViewState get state => _state;

  Future<void> _executar(Future<void> Function() accao) async {
    _state = const ViewState.carregando();
    notifyListeners();
    try {
      await accao();
      _state = const ViewState.sucesso();
    } on AppExceptions catch (e) {
      _state = ViewState.erro(e.msg);
    } catch (e) {
      _state = ViewState.erro('Ocorreu um erro inesperado.');
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarDisciplinas() async {
    await _executar(() async {
      _disciplinas = await _repository.listarDisciplinas();
    });
  }

  Future<void> criarDisciplina({
    required String nome,
    required String codigo,
    required int cargaHoraria,
    String? descricao,
  }) async {
    await _executar(() async {
      final nova = Disciplina(
        id: _uuid.v4(),
        nome: nome.trim(),
        codigo: codigo.trim().toUpperCase(),
        cargaHoraria: cargaHoraria,
        descricao: descricao?.trim(),
      );
      await _repository.guardarDisciplina(nova);
      _disciplinas = await _repository.listarDisciplinas();
    });
  }

  Future<void> actualizarDisciplina(Disciplina disciplina) async {
    await _executar(() async {
      await _repository.actualizarDisciplina(disciplina);
      _disciplinas = await _repository.listarDisciplinas();
    });
  }

  Future<void> removerDisciplina(String id) async {
    await _executar(() async {
      await _repository.removerDisciplina(id);
      _disciplinas = _disciplinas.where((d) => d.id != id).toList();
    });
  }
}