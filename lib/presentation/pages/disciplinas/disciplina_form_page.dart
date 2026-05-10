import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/disciplina.dart';
import '../../viewmodels/disciplina_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class DisciplinaFormPage extends StatefulWidget {
  final Disciplina? disciplina;

  const DisciplinaFormPage({
    super.key,
    this.disciplina,
  });

  @override
  State<DisciplinaFormPage> createState() => _DisciplinaFormPageState();
}

class _DisciplinaFormPageState extends State<DisciplinaFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _codigoController;
  late final TextEditingController _cargaHorariaController;
  late final TextEditingController _descricaoController;

  bool get _isEditing => widget.disciplina != null;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.disciplina?.nome ?? '',
    );

    _codigoController = TextEditingController(
      text: widget.disciplina?.codigo ?? '',
    );

    _cargaHorariaController = TextEditingController(
      text: widget.disciplina?.cargaHoraria.toString() ?? '',
    );

    _descricaoController = TextEditingController(
      text: widget.disciplina?.descricao ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _cargaHorariaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<DisciplinaViewModel>();

    final cargaHoraria = int.parse(_cargaHorariaController.text.trim());

    if (_isEditing) {
      final actualizada = widget.disciplina!.copyWith(
        nome: _nomeController.text.trim(),
        codigo: _codigoController.text.trim().toUpperCase(),
        cargaHoraria: cargaHoraria,
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
      );

      await viewModel.actualizarDisciplina(actualizada);
    } else {
      await viewModel.criarDisciplina(
        nome: _nomeController.text.trim(),
        codigo: _codigoController.text.trim(),
        cargaHoraria: cargaHoraria,
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
      );
    }

    if (!mounted) return;

    if (!viewModel.state.temErro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DisciplinaViewModel>();
    final isLoading = viewModel.state.status == ViewStatus.carregando;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar disciplina' : 'Nova disciplina'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Nome da disciplina',
                controller: _nomeController,
                prefixIcon: Icons.book_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome da disciplina';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Código',
                controller: _codigoController,
                prefixIcon: Icons.code_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o código da disciplina';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Carga horária',
                controller: _cargaHorariaController,
                prefixIcon: Icons.schedule_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a carga horária';
                  }

                  final numero = int.tryParse(value.trim());

                  if (numero == null || numero <= 0) {
                    return 'Informe uma carga horária válida';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Descrição',
                controller: _descricaoController,
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (viewModel.state.temErro)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.state.mensagemErro ?? 'Erro ao guardar disciplina',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppButton(
                label: _isEditing ? 'Actualizar' : 'Guardar',
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