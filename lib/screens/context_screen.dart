import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';

class ContextScreen extends StatelessWidget {
  const ContextScreen({super.key});

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
            backgroundColor: const Color(0xFF0d6b78),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Contexte du Projet',
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
                      Color(0xFF0d6b78),
                      Color(0xFF084c57),
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
                _buildSectionCard(
                  'Problématique',
                  'Les cartes topographiques historiques scannées sont riches en informations géographiques mais difficiles à exploiter dans les SIG modernes. La vectorisation manuelle est chronophage et coûteuse.',
                  Icons.help_outline,
                  const Color(0xFFe74c3c),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  'Objectifs',
                  'Automatiser la conversion de cartes raster en couches vectorielles exploitables, avec un pipeline IA capable de segmenter, vectoriser et géoréférencer les cartes historiques.',
                  Icons.track_changes,
                  const Color(0xFF27ae60),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  'Contexte Académique',
                  "Projet de Fin d'Année (PFA) réalisé dans le cadre de la formation en Géomatique à l'EABA, sous la supervision de M. Kamel BENRAIS (ELFOULADH).",
                  Icons.school_outlined,
                  const Color(0xFF3498db),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildTechChips(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon, Color color) {
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1e293b),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748b),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0d6b78),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('👤', projectInfo.student),
          const SizedBox(height: 10),
          _buildInfoRow('👨‍🏫', projectInfo.supervisor),
          const SizedBox(height: 10),
          _buildInfoRow('🏫', projectInfo.school),
          const SizedBox(height: 10),
          _buildInfoRow('📅', projectInfo.year),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTechChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technologies Clés',
          style: GoogleFonts.inter(
            color: const Color(0xFF1e293b),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: projectInfo.technologies.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0d6b78).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0d6b78).withOpacity(0.3),
                width: 1,
                ),
              ),
              child: Text(
                tech,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0d6b78),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
