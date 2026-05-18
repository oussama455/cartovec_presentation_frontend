import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

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
            backgroundColor: const Color(0xFF27ae60),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Résultats Principaux',
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
                      Color(0xFF27ae60),
                      Color(0xFF1e8449),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Performance Metrics
                _buildSectionTitle('Métriques de Performance'),
                const SizedBox(height: 16),
                _buildMetricsGrid(),
                const SizedBox(height: 32),
                // Output Examples
                _buildSectionTitle('Livrables'),
                const SizedBox(height: 16),
                _buildDeliverablesCard(),
                const SizedBox(height: 32),
                // Dataset Info
                _buildSectionTitle("Données d'Entraînement"),
                const SizedBox(height: 16),
                _buildDatasetCard(),
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

  Widget _buildMetricsGrid() {
    final metrics = [
      ('🎯', 'mIoU', '~0.65', 'U-Net SEMAP', const Color(0xFFe74c3c)),
      ('🗺️', 'Cartes', '8', 'Calibrées HSV', const Color(0xFF3498db)),
      ('📊', 'Classes', '6', 'SEMAP', const Color(0xFFf39c12)),
      ('⚡', 'Échant.', '13,561', 'SEMAP Dataset', const Color(0xFF9b59b6)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(m.$1, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                m.$3,
                style: GoogleFonts.inter(
                  color: m.$5,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                m.$2,
                style: GoogleFonts.inter(
                  color: const Color(0xFF334155),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                m.$4,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94a3b8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliverablesCard() {
    final outputs = [
      ('GeoJSON', 'Couches vectorielles par classe', Icons.layers, const Color(0xFF3498db)),
      ('Shapefile', 'Format ESRI compatible QGIS/ArcGIS', Icons.folder, const Color(0xFF27ae60)),
      ('World File', 'Géoréférencement .pgw/.tfw', Icons.map, const Color(0xFFf39c12)),
      ('Web App', 'Interface React/Vite + Leaflet', Icons.web, const Color(0xFFe74c3c)),
    ];

    return Column(
      children: outputs.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.$4.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.$3, color: item.$4, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1e293b),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
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
      }).toList(),
    );
  }

  Widget _buildDatasetCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9b59b6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.dataset, color: Color(0xFF9b59b6), size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'SEMAP Dataset',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1e293b),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDatasetRow('Échantillons', '13,561'),
          const Divider(height: 16),
          _buildDatasetRow('Classes', '6 (background, contours, built, non_built, water, road_network)'),
          const Divider(height: 16),
          _buildDatasetRow('Source', 'EPFL / Zenodo'),
          const Divider(height: 16),
          _buildDatasetRow('Licence', 'CC BY 4.0'),
        ],
      ),
    );
  }

  Widget _buildDatasetRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF94a3b8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
