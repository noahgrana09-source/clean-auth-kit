import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/auth_wrapper.dart';
import 'firebase_options.dart';

/// Punto de entrada de la aplicación.
///
/// Inicializa Firebase y envuelve toda la app con [ProviderScope]
/// para habilitar el árbol de providers de Riverpod.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones generadas por FlutterFire CLI.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // ProviderScope es el contenedor raíz de todos los providers Riverpod.
    const ProviderScope(child: ProductSearcherApp()),
  );
}

/// Widget raíz de la aplicación.
///
/// Configura los temas Material (Android) y delega la navegación
/// inicial a [AuthWrapper], que decide si mostrar auth o la pantalla principal.
class ProductSearcherApp extends StatelessWidget {
  /// Crea el widget raíz de la aplicación.
  const ProductSearcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Searcher',
      debugShowCheckedModeBanner: false,

      // Temas Material para Android (Cupertino se aplica por widget adaptativo).
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // AuthWrapper observa el stream de auth y redirige según el estado.
      home: const AuthWrapper(),
    );
  }
}
