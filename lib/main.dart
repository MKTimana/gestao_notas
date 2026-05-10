import 'domain/entities/avaliacao.dart';
import 'domain/entities/disciplina.dart';
import 'domain/entities/estudante.dart';

void main() {
  // Criando objectos para validar as entities
  final estudante = Estudante(
    id: '1',
    nome: 'Ana Machava',
    numero: '20250001',
    email: null,          // permitido — é nullable
  );

  final disciplina = Disciplina(
    id: '1',
    nome: 'Programação de Dispositivos Móveis',
    codigo: 'PDM-2025',
    cargaHoraria: 60,
  );

  final avaliacao = Avaliacao(
    id: '1',
    disciplinaId: disciplina.id,
    estudanteId: estudante.id,
    tipo: TipoAvaliacao.teste,
    notaMaxima: 20.0,
    data: DateTime.now(),
    // nota não atribuída ainda
  );

  print(estudante.emailOuPadrao);      // sem.email@isutc.ac.mz
  print(avaliacao.temNota);            // false
  print(avaliacao.classificacao);      // Por avaliar

  // Atribuindo nota com copyWith — SEM mutar o objecto original
  final avaliacaoComNota = avaliacao.copyWith(nota: 17.5);
  print(avaliacaoComNota.percentagem); // 87.5
  print(avaliacaoComNota.classificacao); // Bom
}