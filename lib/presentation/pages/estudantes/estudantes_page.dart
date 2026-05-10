import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class EstudantesPage extends StatefulWidget {
  const EstudantesPage({super.key});

  @override
  State<EstudantesPage> createState() => _EstudantesPageState();
}

class _EstudantesPageState extends State<EstudantesPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudanteViewModel>().carregarEstudantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EstudanteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Estudantes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.estudantesCreate);
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (viewModel.state.status == ViewStatus.carregando) {
            return const LoadingWidget(message: 'A carregar estudantes...');
          }

          if (viewModel.state.temErro) {
            return Center(
              child: Text(
                viewModel.state.mensagemErro ?? 'Erro ao carregar dados',
              ),
            );
          }

          if (viewModel.estudantes.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.people_outline,
              title: 'Nenhum estudante registado',
              subtitle: 'Comece por adicionar o primeiro estudante.',
              actionLabel: 'Adicionar estudante',
              onAction: () {
                Navigator.of(context).pushNamed(RouteNames.estudantesCreate);
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.estudantes.length,
            itemBuilder: (context, index) {
              final estudante = viewModel.estudantes[index];

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(estudante.nome),
                  subtitle: Text(
                    'N.º ${estudante.numero}\n${estudante.emailOuPadrao}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteNames.estudantesEdit,
                      arguments: estudante,
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
