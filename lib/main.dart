import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/auth_wrapper.dart';
import 'firebase_options.dart';

/// Application entry point.
///
/// Initializes Firebase and wraps the whole app with [ProviderScope]
/// to enable the Riverpod provider tree.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Rive's native runtime before loading any .riv file.
  await RiveNative.init();

  runApp(const ProviderScope(child: ProductSearcherApp()));
}

/// Root widget of the application.
///
/// Configures the Material themes (Android) and delegates initial
/// navigation to [AuthWrapper], which decides whether to show auth
/// or the main screen.
class ProductSearcherApp extends StatelessWidget {
  /// Creates the app's root widget.
  const ProductSearcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Auth Kit',
      debugShowCheckedModeBanner: false,

      // Material themes for Android (Cupertino is applied per adaptive widget).
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      home: const AuthWrapper(),
    );
  }
}
