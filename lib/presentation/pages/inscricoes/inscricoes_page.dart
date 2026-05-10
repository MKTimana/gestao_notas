import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/inscricao_view_model.dart';
import '../../viewmodels/view_state.dart';

class InscricoesPage extends StatefulWidget {
  const InscricoesPage({super.key});

  @override
  State<InscricoesPage> createState() => _InscricoesPageState();
}

class _InscricoesPageState extends State<InscricoesPage> {
  String? _estudanteId;
  String? _disciplinaId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudanteViewModel>().carregarEstudantes();
      context.read<DisciplinaViewModel>().carregarDisciplinas();
      context.read<InscricaoViewModel>().carregarInscricoes();
    });
  }

  Future<void> _inscrever() async {
    if (_estudanteId == null || _disciplinaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione estudante e disciplina.'),
        ),
      );
      return;
    }

    final viewModel = context.read<InscricaoViewModel>();

    await viewModel.inscreverEstudante(
      estudanteId: _estudanteId!,
      disciplinaId: _disciplinaId!,
    );

    if (!mounted) return;

    if (!viewModel.state.temErro) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estudante inscrito com sucesso.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final estudanteVM = context.watch<EstudanteViewModel>();
    final disciplinaVM = context.watch<DisciplinaViewModel>();
    final inscricaoVM = context.watch<InscricaoViewModel>();

    final isLoading = inscricaoVM.state.status == ViewStatus.carregando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscrições'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _estudanteId,
              decoration: const InputDecoration(
                labelText: 'Estudante',
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: estudanteVM.estudantes.map((estudante) {
                return DropdownMenuItem(
                  value: estudante.id,
                  child: Text(estudante.nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _estudanteId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _disciplinaId,
              decoration: const InputDecoration(
                labelText: 'Disciplina',
                prefixIcon: Icon(Icons.book_outlined),
              ),
              items: disciplinaVM.disciplinas.map((disciplina) {
                return DropdownMenuItem(
                  value: disciplina.id,
                  child: Text(disciplina.nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _disciplinaId = value;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isLoading ? null : _inscrever,
              icon: const Icon(Icons.check),
              label: Text(isLoading ? 'A guardar...' : 'Inscrever'),
            ),
            const SizedBox(height: 24),
            if (inscricaoVM.state.temErro)
              Text(
                inscricaoVM.state.mensagemErro ?? 'Erro ao inscrever estudante',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Inscrições registadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...inscricaoVM.inscricoes.map((inscricao) {
              final estudante = firstWhereOrNull(
                estudanteVM.estudantes,
                (e) => e.id == inscricao.estudanteId,
              );

              final disciplina = firstWhereOrNull(
                disciplinaVM.disciplinas,
                (d) => d.id == inscricao.disciplinaId,
              );

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.how_to_reg_outlined),
                  title: Text(estudante?.nome ?? 'Estudante não encontrado'),
                  subtitle: Text(disciplina?.nome ?? 'Disciplina não encontrada'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await context
                          .read<InscricaoViewModel>()
                          .removerInscricao(inscricao.id);
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

T? firstWhereOrNull<T>(List<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}