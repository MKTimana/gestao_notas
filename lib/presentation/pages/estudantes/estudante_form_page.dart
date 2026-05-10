import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/estudante.dart';
import '../../viewmodels/estudante_view_model.dart';
import '../../viewmodels/view_state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class EstudanteFormPage extends StatefulWidget {
  final Estudante? estudante;

  const EstudanteFormPage({
    super.key,
    this.estudante,
  });

  @override
  State<EstudanteFormPage> createState() => _EstudanteFormPageState();
}

class _EstudanteFormPageState extends State<EstudanteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _numeroController;
  late final TextEditingController _emailController;

  bool get _isEditing => widget.estudante != null;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.estudante?.nome ?? '',
    );

    _numeroController = TextEditingController(
      text: widget.estudante?.numero ?? '',
    );

    _emailController = TextEditingController(
      text: widget.estudante?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<EstudanteViewModel>();

    if (_isEditing) {
      final actualizado = widget.estudante!.copyWith(
        nome: _nomeController.text.trim(),
        numero: _numeroController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );

      await viewModel.actualizarEstudante(actualizado);
    } else {
      await viewModel.criarEstudante(
        nome: _nomeController.text.trim(),
        numero: _numeroController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );
    }

    if (!mounted) return;

    if (!viewModel.state.temErro) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EstudanteViewModel>();
    final isLoading = viewModel.state.status == ViewStatus.carregando;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar estudante' : 'Novo estudante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Nome completo',
                controller: _nomeController,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do estudante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Número de estudante',
                controller: _numeroController,
                prefixIcon: Icons.badge_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o número do estudante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              if (viewModel.state.temErro)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.state.mensagemErro ?? 'Erro ao guardar estudante',
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