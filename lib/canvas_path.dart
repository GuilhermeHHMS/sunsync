import 'dart:math';
import 'dart:ui';

class CanvasController {
  static Path buildSunPath() {
    final Path path = Path();

    const double centerX = 122; // Posição X do centro do sol
    const double centerY = 105; // Posição Y do centro do sol
    const double radius = 80; // Raio do sol

    // Cria o círculo central do sol
    path.addOval(Rect.fromCircle(
        center: const Offset(centerX, centerY), radius: radius));

    // Desenhe os raios solares
    const double rayLength = radius * 1.5; // Comprimento dos raios
    const double rayAngleIncrement =
        360 / 12; // Ângulo de incremento para os raios

    for (double angle = 0; angle < 360; angle += rayAngleIncrement) {
      final double x1 = centerX + radius * 0.8 * cos((angle * 3.14 / 180));
      final double y1 = centerY + radius * 0.8 * sin((angle * 3.14 / 180));
      final double x2 = centerX + rayLength * cos((angle * 3.14 / 180));
      final double y2 = centerY + rayLength * sin((angle * 3.14 / 180));

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
    }

    return path;
  }
}
