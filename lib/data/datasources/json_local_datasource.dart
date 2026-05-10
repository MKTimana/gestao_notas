import 'dart:convert';
import 'dart:io';
import 'package:gestao_notas/domain/exceptions/app_exceptions.dart';
import 'package:path_provider/path_provider.dart';

class JsonLocalDatasource {
  Future<String> get _pastaDocumentos async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFicheiro(String nomeColeccao) async {
    final pasta = await _pastaDocumentos;
    return File('$pasta/$nomeColeccao.json');
  }

  Future<List<Map<String, dynamic>>> lerTodos(String coleccao) async {
    try {
      final ficheiro = await _getFicheiro(coleccao);
      if (!await ficheiro.exists()) {
        return [];
      }

      final conteudo = await ficheiro.readAsString();
      if (conteudo.trim().isEmpty) return [];

      final lista = jsonDecode(conteudo) as List<dynamic>;
      return lista.cast<Map<String, dynamic>>();
    } on FormatException catch (e) {
      throw PersistenciaException('Ficheiro JSON inválido: ${e.message}');
    } on IOException catch (e) {
      throw PersistenciaException('Erro de leitura: $e');
    }
  }

  Future<void> guardarTodos(
    String coleccao,
    List<Map<String, dynamic>> dados,
  ) async {
    try {
      final ficheiro = await _getFicheiro(coleccao);
      final conteudo = const JsonEncoder.withIndent(' ').convert(dados);
      await ficheiro.writeAsString(conteudo);
    } on IOException catch (e) {
      throw PersistenciaException('Erro de escrita: $e');
    }
  }
}
