import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  /// Optional screen to navigate to once the 6-second splash finishes.
  final Widget? nextScreen;

  /// Optional callback fired right before navigating away.
  final VoidCallback? onFinished;

  /// Duration the splash screen stays visible on initial app open.
  final Duration duration;

  const SplashScreen({
    super.key,
    this.nextScreen,
    this.onFinished,
    this.duration = const Duration(seconds: 15),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bgColor = Color(0xFF121622);
  static const Color _goldColor = Color(0xFFD99B26);
  static const Color _titleColor = Colors.white;
  static const Color _sloganColor = Color(0xFF9AA3B2);
  static const String _logoPath = 'assets/images/logo.png';

  late final AnimationController _dotsController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Animates the circular dotted loader continuously while waiting.
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Keeps the splash screen visible for 6 seconds when the app first opens.
    _timer = Timer(widget.duration, _completeSplash);
  }

  void _completeSplash() {
    if (!mounted) return;

    widget.onFinished?.call();

    final Widget target = widget.nextScreen ?? const _PostSplashPlaceholder();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo, App Name, and Slogan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      _logoPath,
                      width: 156,
                      height: 156,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: _goldColor, width: 2.5),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              color: _goldColor,
                              fontSize: 64,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Galvin's-Library",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Your Academic Knowledge Vault',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _sloganColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Rotating Circular Dotted Loading Indicator
              AnimatedBuilder(
                animation: _dotsController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _dotsController.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CustomPaint(
                    painter: _CircularDottedLoaderPainter(color: _goldColor),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularDottedLoaderPainter extends CustomPainter {
  final Color color;

  const _CircularDottedLoaderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const int dotCount = 12;
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double orbitRadius = radius - 3;

    for (int i = 0; i < totalDotCount(dotCount); i++) {
      final double angle = (-math.pi / 2) + (2 * math.pi * i / dotCount);
      final double progress = (i + 1) / dotCount;
      final double dotRadius = 1.4 + (progress * 1.2);

      final Paint dotPaint = Paint()
        ..color = color.withValues(alpha: 0.2 + (0.8 * progress))
        ..style = PaintingStyle.fill;

      final double dx = center.dx + orbitRadius * math.cos(angle);
      final double dy = center.dy + orbitRadius * math.sin(angle);

      canvas.drawCircle(Offset(dx, dy), dotRadius, dotPaint);
    }
  }

  int totalDotCount(int count) => count;

  @override
  bool shouldRepaint(covariant _CircularDottedLoaderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _PostSplashPlaceholder extends StatelessWidget {
  const _PostSplashPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121622),
      body: Center(
        child: Text(
          'Splash finished after 15s',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
