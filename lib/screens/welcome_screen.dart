import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onGetStarted;
  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _particleCtrl;

  // Master reveal animations
  late Animation<double> _badgeFade;
  late Animation<Offset> _badgeSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _descFade;
  late Animation<Offset> _descSlide;
  late Animation<double> _chipsFade;
  late Animation<double> _btnFade;
  late Animation<Offset> _btnSlide;

  // Continuous animations
  late Animation<double> _floatAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Staggered reveals
    _badgeFade = _fade(0.0, 0.15);
    _badgeSlide = _slide(0.0, 0.15, const Offset(0, -0.5));
    _titleFade = _fade(0.1, 0.35);
    _titleSlide = _slide(0.1, 0.35, const Offset(-0.3, 0));
    _subtitleFade = _fade(0.25, 0.45);
    _subtitleSlide = _slide(0.25, 0.45, const Offset(0.3, 0));
    _descFade = _fade(0.4, 0.65);
    _descSlide = _slide(0.4, 0.65, const Offset(0, 0.3));
    _chipsFade = _fade(0.55, 0.75);
    _btnFade = _fade(0.7, 0.9);
    _btnSlide = _slide(0.7, 0.9, const Offset(0, 0.4));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _masterCtrl.forward();
    });
  }

  Animation<double> _fade(double start, double end) => Tween<double>(
    begin: 0.0, end: 1.0,
  ).animate(CurvedAnimation(
    parent: _masterCtrl,
    curve: Interval(start, end, curve: Curves.easeOut),
  ));

  Animation<Offset> _slide(double start, double end, Offset begin) =>
      Tween<Offset>(begin: begin, end: Offset.zero).animate(CurvedAnimation(
        parent: _masterCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));

  @override
  void dispose() {
    _masterCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0a3d4a),
                  Color(0xFF0d6b78),
                  Color(0xFF084c57),
                  Color(0xFF062d36),
                ],
                stops: [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          // Animated particles
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (context, _) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ParticlePainter(_particleCtrl.value),
            ),
          ),

          // Floating orbs
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (context, _) => Stack(
              children: [
                Positioned(
                  top: 60 + _floatAnim.value,
                  right: -40,
                  child: _buildOrb(200, const Color(0xFF0d6b78), 0.15),
                ),
                Positioned(
                  bottom: 120 - _floatAnim.value,
                  left: -60,
                  child: _buildOrb(160, const Color(0xFF1abc9c), 0.12),
                ),
                Positioned(
                  top: 200 - _floatAnim.value * 0.5,
                  left: 30,
                  child: _buildOrb(80, const Color(0xFF7de2d1), 0.1),
                ),
              ],
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Badge
                  FadeTransition(
                    opacity: _badgeFade,
                    child: SlideTransition(
                      position: _badgeSlide,
                      child: _buildBadge(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title with hero animation
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (context, child) => Transform.scale(
                          scale: 1.0 + (_pulseAnim.value - 1.0) * 0.02,
                          alignment: Alignment.centerLeft,
                          child: child,
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF7de2d1)],
                          ).createShader(bounds),
                          child: Text(
                            projectInfo.title,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -3,
                              height: 0.95,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Subtitle
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: SlideTransition(
                      position: _subtitleSlide,
                      child: Text(
                        projectInfo.subtitle,
                        style: GoogleFonts.dmSans(
                          color: const Color(0xFF7de2d1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Description card
                  FadeTransition(
                    opacity: _descFade,
                    child: SlideTransition(
                      position: _descSlide,
                      child: _buildDescCard(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tech chips
                  FadeTransition(
                    opacity: _chipsFade,
                    child: _buildTechChips(),
                  ),

                  const Spacer(),

                  // CTA Button
                  FadeTransition(
                    opacity: _btnFade,
                    child: SlideTransition(
                      position: _btnSlide,
                      child: _AnimatedButton(onTap: widget.onGetStarted),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer
                  FadeTransition(
                    opacity: _btnFade,
                    child: Center(
                      child: Text(
                        'CartoVec © 2026 · Géomatique EABA',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF7de2d1).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF7de2d1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'PFA 2025–2026  ·  EABA Tunisie',
            style: GoogleFonts.dmMono(
              color: const Color(0xFF7de2d1),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        projectInfo.description,
        style: GoogleFonts.dmSans(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
          height: 1.65,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildTechChips() {
    final techs = projectInfo.technologies.take(6).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(techs.length, (i) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + i * 80),
          curve: Curves.easeOutBack,
          builder: (context, v, child) => Transform.scale(
            scale: v,
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF7de2d1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF7de2d1).withOpacity(0.25),
              ),
            ),
            child: Text(
              techs[i],
              style: GoogleFonts.dmMono(
                color: const Color(0xFF7de2d1).withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Animated CTA button ──────────────────────────────────────────────────────
class _AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedButton({required this.onTap});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7de2d1), Color(0xFF0d6b78)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0d6b78).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Commencer',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF062d36),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_rounded,
                  color: Color(0xFF062d36), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Particle painter ─────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(
    30,
    (i) => _Particle(
      x: math.Random(i * 7).nextDouble(),
      y: math.Random(i * 13).nextDouble(),
      size: math.Random(i * 3).nextDouble() * 3 + 1,
      speed: math.Random(i * 11).nextDouble() * 0.3 + 0.1,
      phase: math.Random(i * 17).nextDouble() * math.pi * 2,
    ),
  );

  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF7de2d1).withOpacity(0.25);
    for (final p in _particles) {
      final y = ((p.y - progress * p.speed) % 1.0) * size.height;
      final x = p.x * size.width +
          math.sin(progress * math.pi * 2 + p.phase) * 20;
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _Particle {
  final double x, y, size, speed, phase;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}