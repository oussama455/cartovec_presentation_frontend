import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';

class ContextScreen extends StatefulWidget {
  const ContextScreen({super.key});

  @override
  State<ContextScreen> createState() => _ContextScreenState();
}

class _ContextScreenState extends State<ContextScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _itemFade(int index) => Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Interval(
      (index * 0.12).clamp(0.0, 0.7),
      ((index * 0.12) + 0.35).clamp(0.0, 1.0),
      curve: Curves.easeOut,
    ),
  ));

  Animation<Offset> _itemSlide(int index) =>
      Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(
            (index * 0.12).clamp(0.0, 0.7),
            ((index * 0.12) + 0.35).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f1923),
      body: CustomScrollView(
        slivers: [
          // Animated SliverAppBar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0d6b78),
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _itemFade(0),
                child: Text(
                  'Contexte du Projet',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              background: _buildAppBarBg(),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section cards with stagger
                _buildAnimatedCard(
                  index: 1,
                  child: _SectionCard(
                    title: 'Problématique',
                    content:
                        'Les cartes topographiques historiques scannées sont riches en informations géographiques mais difficiles à exploiter dans les SIG modernes. La vectorisation manuelle est chronophage et coûteuse.',
                    icon: Icons.help_outline_rounded,
                    color: const Color(0xFFe74c3c),
                    accentChar: '01',
                  ),
                ),
                const SizedBox(height: 16),

                _buildAnimatedCard(
                  index: 2,
                  child: _SectionCard(
                    title: 'Objectifs',
                    content:
                        'Automatiser la conversion de cartes raster en couches vectorielles exploitables, avec un pipeline IA capable de segmenter, vectoriser et géoréférencer les cartes historiques.',
                    icon: Icons.track_changes_rounded,
                    color: const Color(0xFF27ae60),
                    accentChar: '02',
                  ),
                ),
                const SizedBox(height: 16),

                _buildAnimatedCard(
                  index: 3,
                  child: _SectionCard(
                    title: 'Contexte Académique',
                    content:
                        "Projet de Fin d'Année (PFA) réalisé dans le cadre de la formation en Géomatique à l'EABA, sous la supervision de M. Kamel BENRAIS (ELFOULADH).",
                    icon: Icons.school_rounded,
                    color: const Color(0xFF3498db),
                    accentChar: '03',
                  ),
                ),
                const SizedBox(height: 24),

                // Info card
                _buildAnimatedCard(index: 4, child: const _InfoCard()),
                const SizedBox(height: 24),

                // Tech chips section
                FadeTransition(
                  opacity: _itemFade(5),
                  child: SlideTransition(
                    position: _itemSlide(5),
                    child: const _TechSection(),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    return FadeTransition(
      opacity: _itemFade(index),
      child: SlideTransition(
        position: _itemSlide(index),
        child: child,
      ),
    );
  }

  Widget _buildAppBarBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0d6b78), Color(0xFF062d36)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 40,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Icon(
              Icons.map_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section card with animated border ────────────────────────────────────────
class _SectionCard extends StatefulWidget {
  final String title, content, accentChar;
  final IconData icon;
  final Color color;

  const _SectionCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.accentChar,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverCtrl.forward(),
      onTapUp: (_) => _hoverCtrl.reverse(),
      onTapCancel: () => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _elevAnim,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, -4 * _elevAnim.value),
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1a2535),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.color.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left accent + icon
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.accentChar,
                    style: GoogleFonts.dmMono(
                      color: widget.color.withOpacity(0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.content,
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF8899b0),
                        fontSize: 14,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('👤', 'Étudiant', projectInfo.student),
      ('👨‍🏫', 'Encadrant', projectInfo.supervisor),
      ('🏫', 'École', projectInfo.school),
      ('📅', 'Année', projectInfo.year),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0d6b78), Color(0xFF062d36)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0d6b78).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...rows.map((r) => _buildRow(r.$1, r.$2, r.$3)),
        ],
      ),
    );
  }

  Widget _buildRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmMono(
                  color: const Color(0xFF7de2d1).withOpacity(0.65),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tech chips ────────────────────────────────────────────────────────────────
class _TechSection extends StatelessWidget {
  const _TechSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technologies Clés',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(projectInfo.technologies.length, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 500 + i * 60),
              curve: Curves.easeOutBack,
              builder: (context, v, child) => Transform.scale(
                scale: v,
                child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a2535),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF0d6b78).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  projectInfo.technologies[i],
                  style: GoogleFonts.dmMono(
                    color: const Color(0xFF7de2d1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}