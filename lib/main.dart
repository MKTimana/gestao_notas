import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_notas/core/routes/app_router.dart';

import 'core/routes/route_names.dart';
import 'data/datasources/json_local_datasource.dart';
import 'data/repositories/avaliacao_repository_impl.dart';
import 'data/repositories/disciplina_repository_impl.dart';
import 'data/repositories/estudante_repository_impl.dart';
import 'data/repositories/inscricao_repository_impl.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/viewmodels/avaliacao_view_model.dart';
import 'presentation/viewmodels/disciplina_view_model.dart';
import 'presentation/viewmodels/estudante_view_model.dart';
import 'presentation/viewmodels/inscricao_view_model.dart';

void main() {
  final datasource = JsonLocalDatasource();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              EstudanteViewModel(EstudanteRepositoryImpl(datasource)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              DisciplinaViewModel(DisciplinaRepositoryImpl(datasource)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              AvaliacaoViewModel(AvaliacaoRepositoryImpl(datasource)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              InscricaoViewModel(InscricaoRepositoryImpl(datasource)),
        ),
      ],
      child: const GestaoNotasApp(),
    ),
  );
}

class GestaoNotasApp extends StatelessWidget {
  const GestaoNotasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Notas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
