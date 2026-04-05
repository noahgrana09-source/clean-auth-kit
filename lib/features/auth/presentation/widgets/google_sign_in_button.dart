import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_utils.dart';

/// Botón adaptativo para iniciar sesión con Google.
///
/// Muestra el logo de Google junto al texto "Continuar con Google".
/// Renderiza como [CupertinoButton] en iOS y [OutlinedButton] en Material.
/// Incluye soporte para estado de carga.
class GoogleSignInButton extends StatelessWidget {
  /// Callback al presionar el botón.
  final VoidCallback? onPressed;

  /// Si `true`, muestra un indicador de carga.
  final bool isLoading;

  /// Crea un [GoogleSignInButton] adaptativo.
  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoButton(context);
    }
    return _buildMaterialButton(context);
  }

  /// Construye el botón estilo Cupertino (iOS/macOS).
  Widget _buildCupertinoButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: CupertinoButton(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        onPressed: isLoading ? null : onPressed,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: isLoading
            ? CupertinoActivityIndicator(color: colorScheme.onSurface)
            : _buildContent(colorScheme),
      ),
    );
  }

  /// Construye el botón estilo Material (Android/Web).
  Widget _buildMaterialButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surface,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colorScheme.onSurface,
                ),
              )
            : _buildContent(colorScheme),
      ),
    );
  }

  /// Contenido del botón: logo de Google + texto.
  Widget _buildContent(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _GoogleLogo(size: 20),
        const SizedBox(width: 12),
        Text(
          'Continuar con Google',
          style: AppTextStyles.labelLarge.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Logo de Google renderizado con [CustomPainter].
///
/// Dibuja el logo oficial de Google con los 4 colores corporativos
/// sin depender de assets externos.
class _GoogleLogo extends StatelessWidget {
  final double size;

  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _GoogleLogoPainter());
  }
}

/// Painter que dibuja el logo de Google con los colores corporativos.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final center = Offset(s / 2, s / 2);
    final radius = s / 2;
    final strokeWidth = s * 0.2;

    // Azul (derecha-arriba)
    _drawArc(
      canvas,
      center,
      radius,
      strokeWidth,
      -0.4,
      1.2,
      const Color(0xFF4285F4),
    );
    // Verde (derecha-abajo)
    _drawArc(
      canvas,
      center,
      radius,
      strokeWidth,
      0.8,
      0.9,
      const Color(0xFF34A853),
    );
    // Amarillo (izquierda-abajo)
    _drawArc(
      canvas,
      center,
      radius,
      strokeWidth,
      1.7,
      0.8,
      const Color(0xFFFBBC05),
    );
    // Rojo (izquierda-arriba)
    _drawArc(
      canvas,
      center,
      radius,
      strokeWidth,
      2.5,
      0.7,
      const Color(0xFFEA4335),
    );

    // Barra horizontal azul
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(s * 0.48, s * 0.4, s * 0.42, strokeWidth),
      barPaint,
    );
  }

  void _drawArc(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle * 3.14159,
      sweepAngle * 3.14159,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
