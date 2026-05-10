import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/avaliacao.dart';
import '../../viewmodels/avaliacao_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class AtribuirNotaPage extends StatefulWidget {
  final Avaliacao avaliacao;

  const AtribuirNotaPage({
    super.key,
    required this.avaliacao,
  });

  @override
  State<AtribuirNotaPage> createState() => _AtribuirNotaPageState();
}

class _AtribuirNotaPageState extends State<AtribuirNotaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notaController;

  @override
  void initState() {
    super.initState();

    _notaController = TextEditingController(
      text: widget.avaliacao.nota?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final nota = double.parse(_notaController.text.trim());

    final viewModel = context.read<AvaliacaoViewModel>();

    await viewModel.atribuirNota(
      avaliacaoId: widget.avaliacao.id,
      nota: nota,
    );

    if (!mounted) return;

    if (!viewModel.state.temErro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AvaliacaoViewModel>();
    final isLoading = viewModel.state.status == ViewStatus.carregando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuir nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: Text(widget.avaliacao.tipo.name.toUpperCase()),
                  subtitle: Text(
                    'Nota máxima: ${widget.avaliacao.notaMaxima}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nota obtida',
                controller: _notaController,
                prefixIcon: Icons.grade_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a nota';
                  }

                  final nota = double.tryParse(value.trim());

                  if (nota == null || nota < 0) {
                    return 'Informe uma nota válida';
                  }

                  if (nota > widget.avaliacao.notaMaxima) {
                    return 'A nota não pode ser superior à nota máxima';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (viewModel.state.temErro)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.state.mensagemErro ?? 'Erro ao atribuir nota',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppButton(
                label: 'Guardar nota',
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