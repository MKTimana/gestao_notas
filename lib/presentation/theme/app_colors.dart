import 'package:flutter/material.dart';

abstract class AppColors {
  // Primária
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFFD2E3FC);
  static const Color primaryDark = Color(0xFF1557B0);

  // Secundária / Acento
  static const Color accent = Color(0xFF34A853);
  static const Color accentLight = Color(0xFFE6F4EA);

  // Neutros
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);

  // Texto
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textHint = Color(0xFF9AA0A6);

  // Bordas
  static const Color border = Color(0xFFDADCE0);
  static const Color borderFocus = Color(0xFF1A73E8);

  // Semânticas
  static const Color error = Color(0xFFD93025);
  static const Color errorLight = Color(0xFFFCE8E6);
  static const Color warning = Color(0xFFF9AB00);
  static const Color warningLight = Color(0xFFFEF3CD);
  static const Color success = Color(0xFF34A853);
  static const Color successLight = Color(0xFFE6F4EA);
  static const Color info = Color(0xFF1A73E8);
  static const Color infoLight = Color(0xFFD2E3FC);

  // Módulos (por cor por entidade)
  static const Color estudanteColor = Color(0xFF4285F4);
  static const Color estudanteColorLight = Color(0xFFD2E3FC);
  static const Color disciplinaColor = Color(0xFF34A853);
  static const Color disciplinaColorLight = Color(0xFFE6F4EA);
  static const Color avaliacaoColor = Color(0xFFF9AB00);
  static const Color avaliacaoColorLight = Color(0xFFFEF3CD);
  static const Color notaColor = Color(0xFFEA4335);
  static const Color notaColorLight = Color(0xFFFCE8E6);
}