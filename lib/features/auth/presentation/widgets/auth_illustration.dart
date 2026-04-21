import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Ilustración animada para las pantallas de autenticación.
///
/// Muestra un candado sobre un gradiente circular con efecto de flotación
/// y anillos pulsantes. Diseño minimalista acorde a la paleta brand.
class AuthIllustration extends StatefulWidget {
  const AuthIllustration({super.key});

  @override
  State<AuthIllustration> createState() => _AuthIllustrationState();
}

class _AuthIllustrationState extends State<AuthIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _floatController;
  late final AnimationController _glowController;
  late final Animation<double> _floatAnim;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -7, end: 7).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnim, _glowAnim]),
      builder: (context, _) {
        final glowOpacity = isDark
            ? _glowAnim.value * 0.35
            : _glowAnim.value * 0.18;

        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Anillo exterior pulsante
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brand.withValues(alpha: glowOpacity),
                  ),
                ),
                // Anillo intermedio
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brand.withValues(
                      alpha: glowOpacity + 0.06,
                    ),
                  ),
                ),
                // Círculo principal con gradiente
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFB07EFA),
                        AppColors.brand,
                        AppColors.brandDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand.withValues(alpha: 0.45),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                // Ícono de candado
                const Icon(Icons.lock_rounded, size: 34, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
