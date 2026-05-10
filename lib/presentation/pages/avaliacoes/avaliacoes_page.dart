import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/view_state.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AvaliacaoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
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
              child: Text(viewModel.state.mensagemErro ?? 'Erro ao carregar dados'),
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

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.assignment),
                  ),
                  title: Text(avaliacao.tipo.name.toUpperCase()),
                  subtitle: Text(
                    avaliacao.temNota
                        ? 'Nota: ${avaliacao.nota}/${avaliacao.notaMaxima}'
                        : 'Nota máxima: ${avaliacao.notaMaxima} • Por avaliar',
                  ),
                  trailing: const Icon(Icons.chevron_right),
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