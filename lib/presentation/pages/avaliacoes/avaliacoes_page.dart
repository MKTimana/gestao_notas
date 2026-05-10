import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class AvaliacoesPage extends StatefulWidget {
  const AvaliacoesPage({super.key});

  @override
  State<AvaliacoesPage> createState() => _AvaliacoesPageState();
}

class _AvaliacoesPageState extends State<AvaliacoesPage> {
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
    final viewModel = context.watch<AvaliacaoViewModel>();
    final estudanteVM = context.watch<EstudanteViewModel>();
    final disciplinaVM = context.watch<DisciplinaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Avaliações')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.avaliacoesCreate);
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.state.status == ViewStatus.carregando) {
            return const LoadingWidget(message: 'A carregar avaliações...');
          }

          if (viewModel.state.temErro) {
            return Center(
              child: Text(
                viewModel.state.mensagemErro ?? 'Erro ao carregar dados',
              ),
            );
          }

          if (viewModel.avaliacoes.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.assignment_outlined,
              title: 'Nenhuma avaliação registada',
              subtitle: 'Crie avaliações para depois atribuir notas.',
              actionLabel: 'Criar avaliação',
              onAction: () {
                Navigator.of(context).pushNamed(RouteNames.avaliacoesCreate);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.avaliacoes.length,
            itemBuilder: (context, index) {
              final avaliacao = viewModel.avaliacoes[index];
              final estudante = estudanteVM.estudantes
                  .where((e) => e.id == avaliacao.estudanteId)
                  .firstOrNull;

              final disciplina = disciplinaVM.disciplinas
                  .where((d) => d.id == avaliacao.disciplinaId)
                  .firstOrNull;

                  

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.assignment)),
                  title: Text(
                    '${avaliacao.tipo.name.toUpperCase()} • ${disciplina?.nome ?? 'Disciplina não encontrada'}',
                  ),
                  subtitle: Text(
                    '${estudante?.nome ?? 'Estudante não encontrado'}\n'
                    '${avaliacao.temNota ? 'Nota: ${avaliacao.nota}/${avaliacao.notaMaxima}' : 'Por avaliar'}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirmar = await showConfirmDialog(
                        context: context,
                        title: 'Eliminar avaliação',
                        message:
                            'Tem certeza que deseja eliminar esta avaliação?',
                      );

                      if (!confirmar) return;

                      await context.read<AvaliacaoViewModel>().removerAvaliacao(
                        avaliacao.id,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Avaliação eliminada com sucesso.'),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(RouteNames.notasAtribuir, arguments: avaliacao);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
