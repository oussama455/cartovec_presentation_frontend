import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _fade(int i) => Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _ctrl,
      curve: Interval(
        (i * 0.12).clamp(0.0, 0.65),
        ((i * 0.12) + 0.38).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    ),
  );

  Animation<Offset> _slide(int i) =>
      Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(
            (i * 0.12).clamp(0.0, 0.65),
            ((i * 0.12) + 0.38).clamp(0.0, 1.0),
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
          SliverAppBar(
            expandedHeight: 190,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF27ae60),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Résultats Principaux',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: _buildAppBarBg(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Metrics
                FadeTransition(
                  opacity: _fade(0),
                  child: SlideTransition(
                    position: _slide(0),
                    child: _label('Métriques de Performance'),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fade(1),
                  child: SlideTransition(
                    position: _slide(1),
                    child: const _MetricsGrid(),
                  ),
                ),
                const SizedBox(height: 32),

                // Deliverables
                FadeTransition(
                  opacity: _fade(2),
                  child: SlideTransition(
                    position: _slide(2),
                    child: _label('Livrables'),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fade(3),
                  child: SlideTransition(
                    position: _slide(3),
                    child: const _DeliverablesCard(),
                  ),
                ),
                const SizedBox(height: 32),

                // Dataset
                FadeTransition(
                  opacity: _fade(4),
                  child: SlideTransition(
                    position: _slide(4),
                    child: _label("Données d'Entraînement"),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fade(5),
                  child: SlideTransition(
                    position: _slide(5),
                    child: const _DatasetCard(),
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

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.spaceGrotesk(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _buildAppBarBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF27ae60), Color(0xFF1a6b3c)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 50,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 8,
            child: Icon(
              Icons.bar_chart_rounded,
              size: 75,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Metrics grid with counting animation ─────────────────────────────────────
class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('🎯', 'mIoU', '~0.65', 'U-Net SEMAP', Color(0xFFe74c3c)),
      ('🗺️', 'Cartes', '8', 'Calibrées HSV', Color(0xFF3498db)),
      ('📊', 'Classes', '6', 'SEMAP', Color(0xFFf39c12)),
      ('⚡', 'Échant.', '13,561', 'SEMAP Dataset', Color(0xFF9b59b6)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, i) {
        final m = metrics[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + i * 100),
          curve: Curves.easeOutBack,
          builder: (context, v, child) => Transform.scale(
            scale: v,
            child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
          ),
          child: _MetricCard(
            emoji: m.$1,
            label: m.$2,
            value: m.$3,
            sub: m.$4,
            color: m.$5,
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatefulWidget {
  final String emoji, label, value, sub;
  final Color color;

  const _MetricCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
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
        animation: _hoverCtrl,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - _hoverCtrl.value * 0.04,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1a2535),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.color.withOpacity(0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji,
                  style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 10),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [widget.color, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  widget.value,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.sub,
                style: GoogleFonts.dmMono(
                  color: const Color(0xFF8899b0),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Deliverables ─────────────────────────────────────────────────────────────
class _DeliverablesCard extends StatelessWidget {
  const _DeliverablesCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.layers_rounded, 'GeoJSON', 'Couches vectorielles par classe', Color(0xFF3498db)),
      (Icons.folder_rounded, 'Shapefile', 'Format ESRI compatible QGIS/ArcGIS', Color(0xFF27ae60)),
      (Icons.map_rounded, 'World File', 'Géoréférencement .pgw/.tfw', Color(0xFFf39c12)),
      (Icons.web_rounded, 'Web App', 'Interface React/Vite + Leaflet', Color(0xFFe74c3c)),
    ];

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + i * 80),
          curve: Curves.easeOutCubic,
          builder: (context, v, child) => Transform.translate(
            offset: Offset(40 * (1 - v), 0),
            child: Opacity(opacity: v, child: child),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1a2535),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: item.$4.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.$4.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.$1, color: item.$4, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$3,
                        style: GoogleFonts.dmSans(
                          color: const Color(0xFF8899b0),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: item.$4.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Dataset card ──────────────────────────────────────────────────────────────
class _DatasetCard extends StatelessWidget {
  const _DatasetCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Échantillons', '13,561'),
      ('Classes', '6 (background, contours, built, non_built, water, road_network)'),
      ('Source', 'EPFL / Zenodo'),
      ('Licence', 'CC BY 4.0'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2535),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9b59b6).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9b59b6).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9b59b6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.dataset_rounded,
                    color: Color(0xFF9b59b6), size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'SEMAP Dataset',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...rows.map((r) => _buildRow(r.$1, r.$2)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: GoogleFonts.dmMono(
                color: const Color(0xFF8899b0),
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}