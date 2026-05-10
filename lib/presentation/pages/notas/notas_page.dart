import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  String? _disciplinaSelecionadaId;

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
    final disciplinaVM = context.watch<DisciplinaViewModel>();
    final estudanteVM = context.watch<EstudanteViewModel>();

    final avaliacoesFiltradas = _disciplinaSelecionadaId == null
        ? avaliacaoVM.avaliacoes
        : avaliacaoVM.avaliacoes
              .where(
                (avaliacao) =>
                    avaliacao.disciplinaId == _disciplinaSelecionadaId,
              )
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Notas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (_) {
            if (avaliacaoVM.state.status == ViewStatus.carregando) {
              return const LoadingWidget(message: 'A carregar notas...');
            }

            if (avaliacaoVM.state.temErro) {
              return Center(
                child: Text(
                  avaliacaoVM.state.mensagemErro ?? 'Erro ao carregar dados',
                ),
              );
            }

            if (avaliacaoVM.avaliacoes.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.grade_outlined,
                title: 'Ainda não existem notas',
                subtitle:
                    'Crie avaliações e depois atribua notas aos estudantes.',
                actionLabel: 'Criar avaliação',
                onAction: () {
                  Navigator.of(context).pushNamed(RouteNames.avaliacoesCreate);
                },
              );
            }

            return Column(
              children: [
                DropdownButtonFormField<String?>(
                  value: _disciplinaSelecionadaId,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por disciplina',
                    prefixIcon: Icon(Icons.book_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todas as disciplinas'),
                    ),
                    ...disciplinaVM.disciplinas.map((disciplina) {
                      return DropdownMenuItem<String?>(
                        value: disciplina.id,
                        child: Text(disciplina.nome),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _disciplinaSelecionadaId = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                if (avaliacoesFiltradas.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Nenhuma nota encontrada para esta disciplina.',
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: avaliacoesFiltradas.length,
                      itemBuilder: (context, index) {
                        final avaliacao = avaliacoesFiltradas[index];

                        final estudante = firstWhereOrNull(
                          estudanteVM.estudantes,
                          (e) => e.id == avaliacao.estudanteId,
                        );

                        final disciplina = firstWhereOrNull(
                          disciplinaVM.disciplinas,
                          (d) => d.id == avaliacao.disciplinaId,
                        );

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                avaliacao.temNota
                                    ? avaliacao.nota!.toStringAsFixed(0)
                                    : '-',
                              ),
                            ),
                            title: Text(
                              estudante?.nome ?? 'Estudante não encontrado',
                            ),
                            subtitle: Text(
                              '${disciplina?.nome ?? 'Disciplina não encontrada'}\n'
                              '${avaliacao.tipo.name.toUpperCase()} • ${avaliacao.classificacao}',
                            ),
                            isThreeLine: true,
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
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

T? firstWhereOrNull<T>(List<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) {
      return item;
    }
  }

  return null;
}
