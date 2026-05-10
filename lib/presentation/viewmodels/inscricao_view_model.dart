import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/inscricao.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/inscricao_repository.dart';
import 'view_state.dart';

class InscricaoViewModel extends ChangeNotifier {
  final InscricaoRepository _repository;
  final _uuid = const Uuid();

  InscricaoViewModel(this._repository);

  List<Inscricao> _inscricoes = [];
  ViewState _state = const ViewState.inicial();

  List<Inscricao> get inscricoes => List.unmodifiable(_inscricoes);
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
      _state = const ViewState.erro('Ocorreu um erro inesperado.');
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarInscricoes() async {
    await _executar(() async {
      _inscricoes = await _repository.listarInscricoes();
    });
  }

  Future<void> carregarPorDisciplina(String disciplinaId) async {
    await _executar(() async {
      _inscricoes = await _repository.listarPorDisciplina(disciplinaId);
    });
  }

  Future<void> carregarPorEstudante(String estudanteId) async {
    await _executar(() async {
      _inscricoes = await _repository.listarPorEstudante(estudanteId);
    });
  }

  Future<bool> estudanteEstaInscrito({
    required String estudanteId,
    required String disciplinaId,
  }) async {
    return _repository.estudanteEstaInscrito(
      estudanteId: estudanteId,
      disciplinaId: disciplinaId,
    );
  }

  Future<void> inscreverEstudante({
    required String estudanteId,
    required String disciplinaId,
  }) async {
    await _executar(() async {
      final inscricao = Inscricao(
        id: _uuid.v4(),
        estudanteId: estudanteId,
        disciplinaId: disciplinaId,
        dataInscricao: DateTime.now(),
      );

      await _repository.guardarInscricao(inscricao);

      _inscricoes = await _repository.listarInscricoes();
    });
  }

  Future<void> removerInscricao(String id) async {
    await _executar(() async {
      await _repository.removerInscricao(id);
      _inscricoes = _inscricoes.where((i) => i.id != id).toList();
    });
  }
}