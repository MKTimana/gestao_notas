import 'package:flutter/foundation.dart'; // ChangeNotifier
import 'package:uuid/uuid.dart';

import '../../domain/entities/estudante.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/estudante_repository.dart';
import 'view_state.dart';

class EstudanteViewModel extends ChangeNotifier {
  final EstudanteRepository _repository;
  final _uuid = const Uuid();

  EstudanteViewModel(this._repository);

  List<Estudante> _estudantes = [];
  ViewState _state = const ViewState.inicial();

  List<Estudante> get estudantes => List.unmodifiable(_estudantes);
  ViewState get state => _state;

  Future<void> _executar(Future<void> Function() accao) async {
    _state = const ViewState.carregando();
    notifyListeners(); // UI mostra loading

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

  Future<void> carregarEstudantes() async {
    await _executar(() async {
      _estudantes = await _repository.listarEstudantes();
    });
  }

  Future<void> criarEstudante({
    required String nome,
    required String numero,
    String? email,
  }) async {
    await _executar(() async {
      final novo = Estudante(
        id: _uuid.v4(), 
        nome: nome.trim(),
        numero: numero.trim(),
        email: email?.trim(),
      );
      await _repository.guardarEstudante(novo);
      _estudantes = await _repository.listarEstudantes();
    });
  }

  Future<void> actualizarEstudante(Estudante estudante) async {
    await _executar(() async {
      await _repository.actualizarEstudante(estudante);
      _estudantes = await _repository.listarEstudantes();
    });
  }

  Future<void> removerEstudante(String id) async {
    await _executar(() async {
      await _repository.removerEstudante(id);
      _estudantes = _estudantes.where((e) => e.id != id).toList();
    });
  }
  
  List<Estudante> pesquisar(String termo) {
    if (termo.trim().isEmpty) return estudantes;
    final t = termo.toLowerCase();
    return _estudantes
        .where((e) =>
            e.nome.toLowerCase().contains(t) ||
            e.numero.toLowerCase().contains(t))
        .toList();
  }
}