import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/design.dart';
import 'config/routes.dart';

class WasiStudentApp extends StatelessWidget {
  const WasiStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return MaterialApp.router(
      title: 'WasiStudent',
      debugShowCheckedModeBanner: false,
      theme: WasiDesign.lightTheme,
      darkTheme: WasiDesign.darkTheme,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      builder: (context, child) {
        // Si no hay usuario autenticado, forzar pantalla de auth
        if (!authProvider.isAuthenticated && child != null) {
          // El redirect del router se encarga de esto
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
