import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';

class TournamentImage extends StatelessWidget {
  const TournamentImage({
    super.key,
    required this.seed,
    this.height = 130,
    this.icon = Icons.sports_martial_arts_rounded,
  });

  final Color seed;
  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TournamentImagePainter(seed: seed, icon: icon),
      ),
    );
  }
}

class _TournamentImagePainter extends CustomPainter {
  const _TournamentImagePainter({required this.seed, required this.icon});

  final Color seed;
  final IconData icon;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [seed, EliteMartialColors.primary, const Color(0xff06111f)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    _drawLights(canvas, size);
    _drawArena(canvas, size);
    _drawCompetitors(canvas, size);
  }

  void _drawLights(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: .8),
          Colors.white.withValues(alpha: .14),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * .18, size.height * .14),
        radius: size.width * .28,
      ));
    canvas.drawCircle(
      Offset(size.width * .18, size.height * .14),
      size.width * .28,
      lightPaint,
    );
    canvas.drawCircle(
      Offset(size.width * .86, size.height * .2),
      size.width * .24,
      lightPaint,
    );
  }

  void _drawArena(Canvas canvas, Size size) {
    final crowd = Paint()..color = Colors.white.withValues(alpha: .08);
    for (var y = size.height * .34; y < size.height * .56; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 6), crowd);
    }

    final mat = Paint()
      ..color = EliteMartialColors.secondaryContainer.withValues(alpha: .32);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            size.width * .12, size.height * .72, size.width * .76, 12),
        const Radius.circular(8),
      ),
      mat,
    );
  }

  void _drawCompetitors(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white.withValues(alpha: .78)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final body = Paint()..color = Colors.white.withValues(alpha: .84);
    final blue = Paint()
      ..color = EliteMartialColors.inversePrimary.withValues(alpha: .75)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final left = Offset(size.width * .46, size.height * .52);
    final right = Offset(size.width * .59, size.height * .52);
    canvas.drawCircle(left.translate(0, -22), 8, body);
    canvas.drawCircle(right.translate(0, -22), 8, body);
    canvas.drawOval(Rect.fromCenter(center: left, width: 20, height: 34), body);
    canvas.drawOval(
        Rect.fromCenter(center: right, width: 20, height: 34), body);
    canvas.drawLine(left.translate(6, -4), right.translate(50, -30), white);
    canvas.drawLine(right.translate(-5, -2), left.translate(-44, -18), white);
    canvas.drawLine(left.translate(-2, 15), left.translate(-30, 44), white);
    canvas.drawLine(right.translate(3, 15), right.translate(28, 45), white);
    canvas.drawLine(left.translate(-10, -2), left.translate(10, 4), blue);
    canvas.drawLine(right.translate(-10, -2), right.translate(10, 4), blue);
  }

  @override
  bool shouldRepaint(covariant _TournamentImagePainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.icon != icon;
  }
}
