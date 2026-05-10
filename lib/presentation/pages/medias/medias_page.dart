import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class MediasPage extends StatefulWidget {
  const MediasPage({super.key});

  @override
  State<MediasPage> createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AvaliacaoViewModel>().carregarAvaliacoes();
      context.read<EstudanteViewModel>().carregarEstudantes();
      context.read<DisciplinaViewModel>().carregarDisciplinas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final avaliacaoVM = context.watch<AvaliacaoViewModel>();
    final estudanteVM = context.watch<EstudanteViewModel>();
    final disciplinaVM = context.watch<DisciplinaViewModel>();

    if (avaliacaoVM.state.status == ViewStatus.carregando) {
      return const Scaffold(
        body: LoadingWidget(message: 'A calcular médias...'),
      );
    }

    if (avaliacaoVM.avaliacoes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Médias'),
        ),
        body: const EmptyStateWidget(
          icon: Icons.analytics_outlined,
          title: 'Sem avaliações',
          subtitle: 'Crie avaliações e atribua notas para calcular médias.',
        ),
      );
    }

    final avaliacoesComNota = avaliacaoVM.avaliacoes
        .where((avaliacao) => avaliacao.temNota)
        .toList();

    if (avaliacoesComNota.isEmpty) {
      return const Scaffold(
        body: EmptyStateWidget(
          icon: Icons.grade_outlined,
          title: 'Sem notas atribuídas',
          subtitle: 'Atribua notas antes de consultar as médias.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Médias')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: estudanteVM.estudantes.length,
        itemBuilder: (context, index) {
          final estudante = estudanteVM.estudantes[index];

          final avaliacoesDoEstudante = avaliacoesComNota
              .where((a) => a.estudanteId == estudante.id)
              .toList();

          if (avaliacoesDoEstudante.isEmpty) {
            return const SizedBox.shrink();
          }

          final somaPercentagens = avaliacoesDoEstudante.fold<double>(
            0,
            (total, avaliacao) => total + avaliacao.percentagem,
          );

          final mediaPercentual =
              somaPercentagens / avaliacoesDoEstudante.length;

          final mediaEm20 = mediaPercentual * 20 / 100;

          return Card(
            child: ExpansionTile(
              leading: const Icon(Icons.person_outline),
              title: Text(estudante.nome),
              subtitle: Text(
                'Média: ${mediaEm20.toStringAsFixed(1)}/20 '
                '(${mediaPercentual.toStringAsFixed(1)}%)',
              ),
              children: avaliacoesDoEstudante.map((avaliacao) {
                final disciplina = disciplinaVM.disciplinas
                    .where((d) => d.id == avaliacao.disciplinaId)
                    .firstOrNull;

                return ListTile(
                  title: Text(disciplina?.nome ?? 'Disciplina não encontrada'),
                  subtitle: Text(avaliacao.tipo.name.toUpperCase()),
                  trailing: Text('${avaliacao.nota}/${avaliacao.notaMaxima}'),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
