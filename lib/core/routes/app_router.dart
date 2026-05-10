import 'package:flutter/material.dart';
import '../../domain/entities/avaliacao.dart';
import '../../domain/entities/disciplina.dart';
import '../../domain/entities/estudante.dart';
import '../../presentation/pages/avaliacoes/avaliacao_form_page.dart';
import '../../presentation/pages/avaliacoes/avaliacoes_page.dart';
import '../../presentation/pages/disciplinas/disciplina_form_page.dart';
import '../../presentation/pages/disciplinas/disciplinas_page.dart';
import '../../presentation/pages/estudantes/estudante_form_page.dart';
import '../../presentation/pages/estudantes/estudantes_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/inscricoes/inscricoes_page.dart';
import '../../presentation/pages/medias/medias_page.dart';
import '../../presentation/pages/notas/atribuir_nota_page.dart';
import '../../presentation/pages/notas/notas_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _fadeRoute(const SplashPage(), settings);

      case RouteNames.home:
        return _slideRoute(const HomePage(), settings);

      case RouteNames.estudantesList:
        return _slideRoute(const EstudantesPage(), settings);

      case RouteNames.disciplinasList:
        return _slideRoute(const DisciplinasPage(), settings);

      case RouteNames.avaliacoesList:
        return _slideRoute(const AvaliacoesPage(), settings);

      case RouteNames.notasList:
        return _slideRoute(const NotasPage(), settings);

      case RouteNames.estudantesCreate:
        return _slideRoute(const EstudanteFormPage(), settings);

      case RouteNames.estudantesEdit:
        final estudante = settings.arguments as Estudante?;
        return _slideRoute(EstudanteFormPage(estudante: estudante), settings);

      case RouteNames.disciplinasCreate:
        return _slideRoute(const DisciplinaFormPage(), settings);

      case RouteNames.disciplinasEdit:
        final disciplina = settings.arguments as Disciplina?;
        return _slideRoute(
          DisciplinaFormPage(disciplina: disciplina),
          settings,
        );

      case RouteNames.avaliacoesCreate:
        return _slideRoute(const AvaliacaoFormPage(), settings);

      case RouteNames.notasAtribuir:
        final avaliacao = settings.arguments as Avaliacao?;

        if (avaliacao == null) {
          return _slideRoute(
            _notFoundPage('Avaliação não enviada para atribuição de nota'),
            settings,
          );
        }

        return _slideRoute(AtribuirNotaPage(avaliacao: avaliacao), settings);

      case RouteNames.mediasList:
        return _slideRoute(const MediasPage(), settings);

      case RouteNames.inscricoesList:
        return _slideRoute(const InscricoesPage(), settings);

      default:
        return _fadeRoute(_notFoundPage(settings.name), settings);
    }
  }

  // Transição com fade (usada no splash)
  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // Transição com slide da direita (usada na navegação normal)
  static PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, _, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Widget _notFoundPage(String? routeName) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Rota "$routeName" não existe.',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
