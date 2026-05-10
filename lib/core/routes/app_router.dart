import 'package:flutter/material.dart';
import '../../presentation/pages/avaliacoes/avaliacoes_page.dart';
import '../../presentation/pages/disciplinas/disciplinas_page.dart';
import '../../presentation/pages/estudantes/estudantes_page.dart';
import '../../presentation/pages/home/home_page.dart';
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
