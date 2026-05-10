import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/avaliacao.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/avaliacao_repository.dart';
import 'view_state.dart';

class AvaliacaoViewModel extends ChangeNotifier {
  final AvaliacaoRepository _repository;
  final _uuid = const Uuid();

  AvaliacaoViewModel(this._repository);

  List<Avaliacao> _avaliacoes = [];
  double? _mediaActual;
  ViewState _state = const ViewState.inicial();

  List<Avaliacao> get avaliacoes => List.unmodifiable(_avaliacoes);
  double? get mediaActual => _mediaActual;
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

  Future<void> carregarPorDisciplina(String disciplinaId) async {
    await _executar(() async {
      _avaliacoes = await _repository.listarPorDisciplina(disciplinaId);
    });
  }

  Future<void> atribuirNota({
    required String avaliacaoId,
    required double nota,
  }) async {
    await _executar(() async {
      final actual = _avaliacoes.firstWhere((a) => a.id == avaliacaoId);

      final actualizada = actual.copyWith(nota: nota);

      await _repository.actualizarAvaliacao(actualizada);

      _avaliacoes = _avaliacoes
          .map((a) => a.id == avaliacaoId ? actualizada : a)
          .toList();
    });
  }

  Future<void> criarAvaliacao({
    required String disciplinaId,
    required String estudanteId,
    required TipoAvaliacao tipo,
    required double notaMaxima,
    double? nota,
  }) async {
    await _executar(() async {
      final nova = Avaliacao(
        id: _uuid.v4(),
        disciplinaId: disciplinaId,
        estudanteId: estudanteId,
        tipo: tipo,
        notaMaxima: notaMaxima,
        data: DateTime.now(),
        nota: nota,
      );
      await _repository.guardarAvaliacao(nova);
      _avaliacoes = await _repository.listarPorDisciplina(disciplinaId);
    });
  }

  Future<void> calcularMedia({
    required String estudanteId,
    required String disciplinaId,
  }) async {
    await _executar(() async {
      _mediaActual = await _repository.calcularMedia(
        estudanteId,
        disciplinaId,
      );
    });
  }

  Future<void> removerAvaliacao(String id, String disciplinaId) async {
    await _executar(() async {
      await _repository.removerAvaliacao(id);
      _avaliacoes = _avaliacoes.where((a) => a.id != id).toList();
    });
  }
}