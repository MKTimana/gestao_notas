import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AvaliacaoViewModel>().carregarAvaliacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AvaliacaoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.notasAtribuir);
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('Atribuir'),
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.state.status == ViewStatus.carregando) {
            return const LoadingWidget(message: 'A carregar notas...');
          }

          if (viewModel.state.temErro) {
            return Center(
              child: Text(viewModel.state.mensagemErro ?? 'Erro ao carregar dados'),
            );
          }

          if (viewModel.avaliacoes.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.grade_outlined,
              title: 'Ainda não existem notas',
              subtitle: 'Crie avaliações e depois atribua notas aos estudantes.',
              actionLabel: 'Atribuir nota',
              onAction: () {
                Navigator.of(context).pushNamed(RouteNames.notasAtribuir);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.avaliacoes.length,
            itemBuilder: (context, index) {
              final avaliacao = viewModel.avaliacoes[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      avaliacao.temNota ? avaliacao.nota!.toStringAsFixed(0) : '-',
                    ),
                  ),
                  title: Text(avaliacao.tipo.name.toUpperCase()),
                  subtitle: Text(avaliacao.classificacao),
                  trailing: Text(
                    avaliacao.temNota
                        ? '${avaliacao.percentagem.toStringAsFixed(1)}%'
                        : 'Pendente',
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.notasAtribuir,
                      arguments: avaliacao,
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