import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';

class ArchitectureScreen extends StatelessWidget {
  const ArchitectureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF9b59b6),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Méthodologie',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF9b59b6),
                      Color(0xFF8e44ad),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_tree,
                    size: 60,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Pipeline de Traitement'),
                const SizedBox(height: 12),
                _buildPipelineFlow(),
                const SizedBox(height: 32),
                _buildSectionTitle('Étapes Détaillées'),
                const SizedBox(height: 16),
                ...architectureSteps.asMap().entries.map((entry) {
                  return _buildStepCard(entry.key, entry.value);
                }).toList(),
                const SizedBox(height: 32),
                _buildSectionTitle('Stack Technique'),
                const SizedBox(height: 16),
                _buildTechStack(),
                const SizedBox(height: 32),
                _buildSectionTitle('Flux de Données'),
                const SizedBox(height: 12),
                _buildDataFlow(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: const Color(0xFF1e293b),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPipelineFlow() {
    final steps = [
      ('Raster', Icons.image, const Color(0xFF64748b)),
      ('Prétrait.', Icons.tune, const Color(0xFF94a3b8)),
      ('Segment.', Icons.auto_awesome_mosaic, const Color(0xFF3498db)),
      ('Vector.', Icons.polyline, const Color(0xFFe74c3c)),
      ('Géoréf.', Icons.map, const Color(0xFF27ae60)),
      ('Export', Icons.code, const Color(0xFFf39c12)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: steps.asMap().entries.map((entry) {
            final isLast = entry.key == steps.length - 1;
            return Row(
              children: [
                _buildFlowStep(entry.value.$1, entry.value.$2, entry.value.$3),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFlowStep(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(int index, ArchitectureStep step) {
    final colors = [
      const Color(0xFF3498db),
      const Color(0xFFe74c3c),
      const Color(0xFF27ae60),
      const Color(0xFFf39c12),
      const Color(0xFF9b59b6),
      const Color(0xFF1abc9c),
    ];
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          step.title,
          style: GoogleFonts.inter(
            color: const Color(0xFF1e293b),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          step.description,
          style: GoogleFonts.inter(
            color: const Color(0xFF64748b),
            fontSize: 13,
          ),
        ),
        iconColor: color,
        collapsedIconColor: Colors.grey.shade400,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFf8fafc),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: step.details.map((detail) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          detail,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF475569),
                            fontSize: 14,
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
        ],
      ),
    );
  }

  Widget _buildTechStack() {
    final categories = [
      (
        'Vision & IA',
        [
          ('OpenCV', '4.9+', const Color(0xFF5c3ee8)),
          ('PyTorch', '2.2+', const Color(0xFFee4c2c)),
          ('SMP', '0.3.3+', const Color(0xFF3498db)),
          ('LangGraph', '0.1+', const Color(0xFF1c3c3c)),
        ]
      ),
      (
        'Géospatial',
        [
          ('GeoPandas', '0.14+', const Color(0xFF139c5a)),
          ('Rasterio', '1.3+', const Color(0xFF0d6b78)),
          ('Shapely', '2.0+', const Color(0xFF2ecc71)),
          ('GDAL', '3.8+', const Color(0xFF4e9b4e)),
        ]
      ),
      (
        'Web',
        [
          ('Django', '5.0+', const Color(0xFF092e20)),
          ('DRF', '3.15+', const Color(0xFFa30000)),
          ('React', '18+', const Color(0xFF61dafb)),
          ('Vite', '5.2+', const Color(0xFF646cff)),
        ]
      ),
    ];

    return Column(
      children: categories.map((cat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cat.$1,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1e293b),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cat.$2.map((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: tech.$3.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: tech.$3.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tech.$3,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tech.$1,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF334155),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tech.$2,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF94a3b8),
                            fontSize: 11,
                          ),
                        ),
                      ],
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

  Widget _buildDataFlow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFlowRow('Frontend', 'React + Leaflet', 'Upload & Correction', Icons.web, const Color(0xFF61dafb)),
          _buildFlowArrow(),
          _buildFlowRow('API', 'Django REST', 'Endpoints /api/maps/', Icons.api, const Color(0xFF092e20)),
          _buildFlowArrow(),
          _buildFlowRow('Pipeline', 'Python Agent', 'Traitement IA + Vectorisation', Icons.memory, const Color(0xFFee4c2c)),
          _buildFlowArrow(),
          _buildFlowRow('Output', 'GeoJSON/SHP', 'Couches vectorielles', Icons.layers, const Color(0xFF27ae60)),
        ],
      ),
    );
  }

  Widget _buildFlowRow(String label, String tech, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
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
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1e293b),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.inter(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748b),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Icon(
        Icons.arrow_downward,
        color: Colors.grey.shade400,
        size: 24,
      ),
    );
  }
}
