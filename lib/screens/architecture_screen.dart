import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';

class ArchitectureScreen extends StatefulWidget {
  const ArchitectureScreen({super.key});

  @override
  State<ArchitectureScreen> createState() => _ArchitectureScreenState();
}

class _ArchitectureScreenState extends State<ArchitectureScreen>
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
        (i * 0.1).clamp(0.0, 0.65),
        ((i * 0.1) + 0.35).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    ),
  );

  Animation<Offset> _slide(int i) =>
      Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(
            (i * 0.1).clamp(0.0, 0.65),
            ((i * 0.1) + 0.35).clamp(0.0, 1.0),
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
            backgroundColor: const Color(0xFF9b59b6),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Méthodologie',
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
                // Pipeline flow
                FadeTransition(
                  opacity: _fade(0),
                  child: SlideTransition(
                    position: _slide(0),
                    child: _buildLabel('Pipeline de Traitement'),
                  ),
                ),
                const SizedBox(height: 14),
                FadeTransition(
                  opacity: _fade(1),
                  child: SlideTransition(
                    position: _slide(1),
                    child: const _AnimatedPipelineFlow(),
                  ),
                ),
                const SizedBox(height: 32),

                // Steps
                FadeTransition(
                  opacity: _fade(2),
                  child: SlideTransition(
                    position: _slide(2),
                    child: _buildLabel('Étapes Détaillées'),
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(architectureSteps.length, (i) {
                  return FadeTransition(
                    opacity: _fade(i + 3),
                    child: SlideTransition(
                      position: _slide(i + 3),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AnimatedStepCard(
                          step: architectureSteps[i],
                          index: i,
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 32),

                // Stack
                FadeTransition(
                  opacity: _fade(10),
                  child: SlideTransition(
                    position: _slide(10),
                    child: _buildLabel('Stack Technique'),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fade(11),
                  child: SlideTransition(
                    position: _slide(11),
                    child: const _TechStackWidget(),
                  ),
                ),

                const SizedBox(height: 32),

                // Data flow
                FadeTransition(
                  opacity: _fade(12),
                  child: SlideTransition(
                    position: _slide(12),
                    child: _buildLabel('Flux de Données'),
                  ),
                ),
                const SizedBox(height: 14),
                FadeTransition(
                  opacity: _fade(13),
                  child: SlideTransition(
                    position: _slide(13),
                    child: const _DataFlowWidget(),
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

  Widget _buildLabel(String text) => Text(
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
          colors: [Color(0xFF9b59b6), Color(0xFF6c3483)],
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
            bottom: 10,
            child: Icon(
              Icons.account_tree_rounded,
              size: 70,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated pipeline flow ───────────────────────────────────────────────────
class _AnimatedPipelineFlow extends StatefulWidget {
  const _AnimatedPipelineFlow();

  @override
  State<_AnimatedPipelineFlow> createState() => _AnimatedPipelineFlowState();
}

class _AnimatedPipelineFlowState extends State<_AnimatedPipelineFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _lineAnim;
  int _activeStep = -1;

  final _steps = [
    ('Raster', Icons.image_rounded, Color(0xFF64748b)),
    ('Prétrait.', Icons.tune_rounded, Color(0xFF94a3b8)),
    ('Segment.', Icons.auto_awesome_mosaic_rounded, Color(0xFF3498db)),
    ('Vector.', Icons.polyline_rounded, Color(0xFFe74c3c)),
    ('Géoréf.', Icons.map_rounded, Color(0xFF27ae60)),
    ('Export', Icons.upload_rounded, Color(0xFFf39c12)),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _lineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    _ctrl.addListener(() {
      final step = (_ctrl.value * _steps.length).floor();
      if (step != _activeStep) {
        setState(() => _activeStep = step);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2535),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Arrow between steps
              final stepIndex = i ~/ 2;
              final isActive = stepIndex < _activeStep;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: isActive
                        ? const Color(0xFF7de2d1)
                        : Colors.white.withOpacity(0.15),
                    size: 18,
                  ),
                ),
              );
            }
            final stepIndex = i ~/ 2;
            final step = _steps[stepIndex];
            final isActive = stepIndex == _activeStep;
            final isDone = stepIndex < _activeStep;
            return _buildFlowStep(step.$1, step.$2, step.$3, isActive, isDone);
          }),
        ),
      ),
    );
  }

  Widget _buildFlowStep(
    String label,
    IconData icon,
    Color color,
    bool isActive,
    bool isDone,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive
                  ? color.withOpacity(0.3)
                  : isDone
                      ? color.withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive
                    ? color
                    : isDone
                        ? color.withOpacity(0.4)
                        : Colors.transparent,
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isActive || isDone ? color : Colors.white.withOpacity(0.3),
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: GoogleFonts.dmMono(
              color: isActive
                  ? color
                  : isDone
                      ? Colors.white.withOpacity(0.6)
                      : Colors.white.withOpacity(0.25),
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

// ── Animated step card ───────────────────────────────────────────────────────
class _AnimatedStepCard extends StatefulWidget {
  final ArchitectureStep step;
  final int index;

  const _AnimatedStepCard({required this.step, required this.index});

  @override
  State<_AnimatedStepCard> createState() => _AnimatedStepCardState();
}

class _AnimatedStepCardState extends State<_AnimatedStepCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expandAnim;
  bool _isExpanded = false;

  static const _colors = [
    Color(0xFF3498db),
    Color(0xFFe74c3c),
    Color(0xFF27ae60),
    Color(0xFFf39c12),
    Color(0xFF9b59b6),
    Color(0xFF1abc9c),
  ];

  Color get _color => _colors[widget.index % _colors.length];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _isExpanded
              ? const Color(0xFF1e2d40)
              : const Color(0xFF1a2535),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isExpanded
                ? _color.withOpacity(0.4)
                : Colors.white.withOpacity(0.06),
            width: _isExpanded ? 1.5 : 1,
          ),
          boxShadow: _isExpanded
              ? [
                  BoxShadow(
                    color: _color.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(_isExpanded ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      widget.step.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.step.title,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.step.description,
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF8899b0),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animated chevron
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _isExpanded ? _color : Colors.white.withOpacity(0.3),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Expanded content
            SizeTransition(
              sizeFactor: _expandAnim,
              child: FadeTransition(
                opacity: _expandAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: widget.step.details.map((d) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  d,
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xFF8899b0),
                                    fontSize: 13.5,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tech stack ────────────────────────────────────────────────────────────────
class _TechStackWidget extends StatelessWidget {
  const _TechStackWidget();

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Vision & IA', [
        ('OpenCV', Color(0xFF5c3ee8)),
        ('PyTorch', Color(0xFFee4c2c)),
        ('SMP', Color(0xFF3498db)),
        ('LangGraph', Color(0xFF1abc9c)),
      ]),
      ('Géospatial', [
        ('GeoPandas', Color(0xFF139c5a)),
        ('Rasterio', Color(0xFF0d6b78)),
        ('Shapely', Color(0xFF2ecc71)),
        ('GDAL', Color(0xFF4e9b4e)),
      ]),
      ('Web', [
        ('Django', Color(0xFF27ae60)),
        ('DRF', Color(0xFFa30000)),
        ('React', Color(0xFF61dafb)),
        ('Vite', Color(0xFF646cff)),
      ]),
    ];

    return Column(
      children: categories.map((cat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1a2535),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat.$1,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cat.$2.map((t) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    builder: (context, v, child) =>
                        Transform.scale(scale: v, child: child),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: t.$2.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: t.$2.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: t.$2,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            t.$1,
                            style: GoogleFonts.dmMono(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Data flow ─────────────────────────────────────────────────────────────────
class _DataFlowWidget extends StatefulWidget {
  const _DataFlowWidget();

  @override
  State<_DataFlowWidget> createState() => _DataFlowWidgetState();
}

class _DataFlowWidgetState extends State<_DataFlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _dotAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _dotAnim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      (Icons.web_rounded, 'Frontend', 'React + Leaflet', 'Upload & Correction', Color(0xFF61dafb)),
      (Icons.api_rounded, 'API', 'Django REST', 'Endpoints /api/maps/', Color(0xFF27ae60)),
      (Icons.memory_rounded, 'Pipeline', 'Python Agent', 'Traitement IA + Vectorisation', Color(0xFFee4c2c)),
      (Icons.layers_rounded, 'Output', 'GeoJSON/SHP', 'Couches vectorielles', Color(0xFFf39c12)),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2535),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: List.generate(rows.length * 2 - 1, (i) {
          if (i.isOdd) {
            return AnimatedBuilder(
              animation: _dotAnim,
              builder: (context, _) {
                final progress = (_dotAnim.value - i / (rows.length * 2 - 1)).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 28),
                  child: Row(
                    children: [
                      Container(
                        width: 2,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF7de2d1).withOpacity(0.6),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          final row = rows[i ~/ 2];
          return _buildFlowRow(row.$1, row.$2, row.$3, row.$4, row.$5);
        }),
      ),
    );
  }

  Widget _buildFlowRow(
    IconData icon,
    String label,
    String tech,
    String desc,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.dmMono(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF8899b0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}