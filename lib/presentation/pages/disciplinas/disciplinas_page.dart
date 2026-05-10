import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class DisciplinasPage extends StatefulWidget {
  const DisciplinasPage({super.key});

  @override
  State<DisciplinasPage> createState() => _DisciplinasPageState();
}

class _DisciplinasPageState extends State<DisciplinasPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DisciplinaViewModel>().carregarDisciplinas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DisciplinaViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Disciplinas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.disciplinasCreate);
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.state.status == ViewStatus.carregando) {
            return const LoadingWidget(message: 'A carregar disciplinas...');
          }

          if (viewModel.state.temErro) {
            return Center(
              child: Text(
                viewModel.state.mensagemErro ?? 'Erro ao carregar dados',
              ),
            );
          }

          if (viewModel.disciplinas.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.book_outlined,
              title: 'Nenhuma disciplina registada',
              subtitle: 'Adicione disciplinas para começar a gerir avaliações.',
              actionLabel: 'Adicionar disciplina',
              onAction: () {
                Navigator.of(context).pushNamed(RouteNames.disciplinasCreate);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.disciplinas.length,
            itemBuilder: (context, index) {
              final disciplina = viewModel.disciplinas[index];

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.book)),
                  title: Text(disciplina.nome),
                  subtitle: Text(
                    '${disciplina.codigo} • ${disciplina.cargaHoraria}h',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirmar = await showConfirmDialog(
                        context: context,
                        title: 'Eliminar disciplina',
                        message:
                            'Tem certeza que deseja eliminar ${disciplina.nome}?',
                      );

                      if (!confirmar) return;

                      await context
                          .read<DisciplinaViewModel>()
                          .removerDisciplina(disciplina.id);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Disciplina eliminada com sucesso.'),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.disciplinasEdit,
                      arguments: disciplina,
                    );
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
