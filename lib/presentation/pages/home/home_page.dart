import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Gestão de Notas'), actions: [
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildModulesGrid(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            'Bem-vindo',
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Gere estudantes, disciplinas e avaliações',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(BuildContext context) {
    final modules = [
      _ModuleItem(
        title: 'Estudantes',
        subtitle: 'Gerir inscrições',
        icon: Icons.people_rounded,
        color: AppColors.estudanteColor,
        lightColor: AppColors.estudanteColorLight,
        route: RouteNames.estudantesList,
      ),
      _ModuleItem(
        title: 'Disciplinas',
        subtitle: 'Cursos e módulos',
        icon: Icons.book_rounded,
        color: AppColors.disciplinaColor,
        lightColor: AppColors.disciplinaColorLight,
        route: RouteNames.disciplinasList,
      ),
      _ModuleItem(
        title: 'Avaliações',
        subtitle: 'Testes e trabalhos',
        icon: Icons.assignment_rounded,
        color: AppColors.avaliacaoColor,
        lightColor: AppColors.avaliacaoColorLight,
        route: RouteNames.avaliacoesList,
      ),
      _ModuleItem(
        title: 'Notas',
        subtitle: 'Resultados e médias',
        icon: Icons.grade_rounded,
        color: AppColors.notaColor,
        lightColor: AppColors.notaColorLight,
        route: RouteNames.notasList,
      ),
      _ModuleItem(
        title: 'Médias',
        subtitle: 'Consultar médias dos estudantes',
        icon: Icons.analytics_outlined,
        color: AppColors.textSecondary,
        lightColor: AppColors.notaColorLight,
        route: RouteNames.mediasList,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Módulos', style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: modules.map((m) => _ModuleCard(item: m)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acções rápidas', style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),
        _QuickActionTile(
          icon: Icons.person_add_rounded,
          iconColor: AppColors.estudanteColor,
          iconBgColor: AppColors.estudanteColorLight,
          title: 'Novo estudante',
          subtitle: 'Registar um novo estudante',
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.estudantesCreate),
        ),
        _QuickActionTile(
          icon: Icons.library_add_rounded,
          iconColor: AppColors.disciplinaColor,
          iconBgColor: AppColors.disciplinaColorLight,
          title: 'Nova disciplina',
          subtitle: 'Criar uma nova disciplina',
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.disciplinasCreate),
        ),
        _QuickActionTile(
          icon: Icons.edit_note_rounded,
          iconColor: AppColors.avaliacaoColor,
          iconBgColor: AppColors.avaliacaoColorLight,
          title: 'Atribuir notas',
          subtitle: 'Lançar resultados de avaliação',
          onTap: () => Navigator.of(context).pushNamed(RouteNames.notasList),
        ),
      ],
    );
  }
}

// ── Modelos internos ───────────────────────────────────────────────────────────

class _ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final String route;

  const _ModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.route,
  });
}

// ── Widgets internos ───────────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  final _ModuleItem item;
  const _ModuleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(item.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.lightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const Spacer(),
            Text(item.title, style: AppTextStyles.titleSmall),
            const SizedBox(height: 2),
            Text(item.subtitle, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: AppTextStyles.titleSmall),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
