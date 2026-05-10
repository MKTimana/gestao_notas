import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/avaliacao.dart';
import '../../../domain/entities/disciplina.dart';
import '../../../domain/entities/estudante.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/inscricao_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class AvaliacaoFormPage extends StatefulWidget {
  const AvaliacaoFormPage({super.key});

  @override
  State<AvaliacaoFormPage> createState() => _AvaliacaoFormPageState();
}

class _AvaliacaoFormPageState extends State<AvaliacaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  Estudante? _estudanteSelecionado;
  Disciplina? _disciplinaSelecionada;
  TipoAvaliacao _tipoSelecionado = TipoAvaliacao.teste;

  final _notaMaximaController = TextEditingController(text: '20');
  final _notaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EstudanteViewModel>().carregarEstudantes();
      context.read<DisciplinaViewModel>().carregarDisciplinas();
    });
  }

  @override
  void dispose() {
    _notaMaximaController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_estudanteSelecionado == null || _disciplinaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione estudante e disciplina.')),
      );
      return;
    }

    final notaMaxima = double.parse(_notaMaximaController.text.trim());

    final nota = _notaController.text.trim().isEmpty
        ? null
        : double.parse(_notaController.text.trim());

    if (nota != null && nota > notaMaxima) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A nota não pode ser superior à nota máxima.'),
        ),
      );
      return;
    }

    final viewModel = context.read<AvaliacaoViewModel>();
    final inscricaoVM = context.read<InscricaoViewModel>();

    final estaInscrito = await inscricaoVM.estudanteEstaInscrito(
      estudanteId: _estudanteSelecionado!.id,
      disciplinaId: _disciplinaSelecionada!.id,
    );

    if (!estaInscrito) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este estudante não está inscrito nesta disciplina.'),
        ),
      );
      return;
    }

    await viewModel.criarAvaliacao(
      disciplinaId: _disciplinaSelecionada!.id,
      estudanteId: _estudanteSelecionado!.id,
      tipo: _tipoSelecionado,
      notaMaxima: notaMaxima,
      nota: nota,
    );

    if (!mounted) return;

    if (!viewModel.state.temErro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final estudanteVM = context.watch<EstudanteViewModel>();
    final disciplinaVM = context.watch<DisciplinaViewModel>();
    final avaliacaoVM = context.watch<AvaliacaoViewModel>();

    final isLoading = avaliacaoVM.state.status == ViewStatus.carregando;

    return Scaffold(
      appBar: AppBar(title: const Text('Nova avaliação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Estudante>(
                value: _estudanteSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Estudante',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: estudanteVM.estudantes.map((estudante) {
                  return DropdownMenuItem(
                    value: estudante,
                    child: Text(estudante.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estudanteSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione o estudante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Disciplina>(
                value: _disciplinaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Disciplina',
                  prefixIcon: Icon(Icons.book_outlined),
                ),
                items: disciplinaVM.disciplinas.map((disciplina) {
                  return DropdownMenuItem(
                    value: disciplina,
                    child: Text(disciplina.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _disciplinaSelecionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione a disciplina';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TipoAvaliacao>(
                value: _tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de avaliação',
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                items: TipoAvaliacao.values.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _tipoSelecionado = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nota máxima',
                controller: _notaMaximaController,
                prefixIcon: Icons.stacked_bar_chart_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a nota máxima';
                  }

                  final notaMaxima = double.tryParse(value.trim());

                  if (notaMaxima == null || notaMaxima <= 0) {
                    return 'Informe uma nota máxima válida';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nota obtida opcional',
                controller: _notaController,
                prefixIcon: Icons.grade_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  final nota = double.tryParse(value.trim());

                  if (nota == null || nota < 0) {
                    return 'Informe uma nota válida';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (avaliacaoVM.state.temErro)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    avaliacaoVM.state.mensagemErro ?? 'Erro ao criar avaliação',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppButton(
                label: 'Guardar avaliação',
                icon: Icons.save_outlined,
                fullWidth: true,
                isLoading: isLoading,
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
