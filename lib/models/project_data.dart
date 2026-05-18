class ProjectInfo {
  final String title;
  final String subtitle;
  final String description;
  final String student;
  final String supervisor;
  final String school;
  final String year;
  final String email;
  final List<String> technologies;
  final List<String> features;

  const ProjectInfo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.student,
    required this.supervisor,
    required this.school,
    required this.year,
    required this.email,
    required this.technologies,
    required this.features,
  });
}

class UserCardInfo {
  final String name;
  final String role;
  final String team;
  final String avatar;
  final List<String> metadata;

  const UserCardInfo({
    required this.name,
    required this.role,
    required this.team,
    required this.avatar,
    required this.metadata,
  });
}

class TaskItem {
  final String name;
  final String startDate;
  final String? finishDate;
  final double progress;
  final String status;

  const TaskItem({
    required this.name,
    required this.startDate,
    this.finishDate,
    required this.progress,
    required this.status,
  });

  // Factory to parse live Django REST task records cleanly
  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      name: json['title'] ?? '',
      startDate: json['start_date'] ?? 'Sept 2025',
      finishDate: json['finish_date'],
      progress: json['status'] == 'completed' ? 100.0 : 40.0,
      status: json['status'] ?? 'todo',
    );
  }
}

class MilestoneItem {
  final String title;
  final String date;
  final String description;
  final bool isCompleted;

  const MilestoneItem({
    required this.title,
    required this.date,
    required this.description,
    required this.isCompleted,
  });

  // Factory to parse live Django REST timeline records cleanly
  factory MilestoneItem.fromJson(Map<String, dynamic> json) {
    return MilestoneItem(
      title: json['title'] ?? '',
      date: json['date_range'] ?? '',
      description: json['achievement_details'] ?? '',
      isCompleted: json['progress_percentage'] == 100,
    );
  }
}

class ArchitectureStep {
  final String title;
  final String description;
  final String icon;
  final List<String> details;

  const ArchitectureStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.details,
  });
}

class TimelineEvent {
  final String date;
  final String title;
  final String description;
  final bool isCompleted;
  final double progress;

  const TimelineEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.progress,
  });
}

class BibliographyEntry {
  final String title;
  final String authors;
  final String year;
  final String source;
  final String? url;
  final String type;

  const BibliographyEntry({
    required this.title,
    required this.authors,
    required this.year,
    required this.source,
    this.url,
    required this.type,
  });

  // Factory to parse live Django REST bibliography records cleanly
  factory BibliographyEntry.fromJson(Map<String, dynamic> json) {
    return BibliographyEntry(
      title: json['title'] ?? '',
      authors: json['authors'] ?? '',
      year: json['year'] ?? '2026',
      source: json['source_info'] ?? '',
      url: json['url'],
      type: json['ref_type'] ?? 'article',
    );
  }
}

// ==================== STATIC DATA INSTANCES ====================

final projectInfo = const ProjectInfo(
  title: 'CartoVec',
  subtitle: 'Vectorisation Automatique de Cartes Historiques',
  description: 'CartoVec transforme des cartes topographiques raster scannées en couches vectorielles exploitables dans un SIG. Le projet combine un pipeline Python (OpenCV/PyTorch/GeoPandas), un agent IA basé sur LangGraph, une API Django REST et une interface React/Vite avec Leaflet pour visualiser et corriger les résultats.',
  student: 'Oussama CHOUAIBI',
  supervisor: 'Kamel BENRAIS',
  school: 'EABA - Tunisie',
  year: '2026',
  email: 'ochouaibi1919@gmail.com',
  technologies: [
    'Python 3.10',
    'OpenCV',
    'PyTorch',
    'GeoPandas',
    'Django 5.0',
    'React 18',
    'Vite',
    'Leaflet',
    'LangGraph',
    'U-Net',
  ],
  features: [
    'Segmentation HSV calibrée',
    'Segmentation sémantique U-Net',
    'Détection automatique du cadre',
    'Agent IA avec auto-correction',
    'Active Learning adaptatif',
    'Géoréférencement automatique',
    'Export GeoJSON/Shapefile',
    'Interface web interactive',
  ],
);

final userCardInfo = const UserCardInfo(
  name: 'Oussama CHOUAIBI',
  role: 'Étudiant en Géomatique',
  team: 'EABA Tunisie',
  avatar: '👤',
  metadata: [
    'PFA 2025-2026',
    '2ème Année Géomatique',
    'Encadrant: Kamel BENRAIS',
    'ELFOULADH',
  ],
);

final tasksList = [
  const TaskItem(
    name: 'Analyse des besoins & cadrage',
    startDate: 'Sept 2025',
    finishDate: 'Sept 2025',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Pipeline Python de base',
    startDate: 'Oct 2025',
    finishDate: 'Oct 2025',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Calibration HSV',
    startDate: 'Nov 2025',
    finishDate: 'Nov 2025',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Segmentation IA (U-Net)',
    startDate: 'Déc 2025',
    finishDate: 'Déc 2025',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Agent IA & Active Learning',
    startDate: 'Jan 2026', // Fixed typo here!
    finishDate: 'Jan 2026',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Détection du cadre cartographique',
    startDate: 'Fév 2026',
    finishDate: 'Fév 2026',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Application Web (Django + React)',
    startDate: 'Mars 2026',
    finishDate: 'Mars 2026',
    progress: 100.0,
    status: 'completed',
  ),
  const TaskItem(
    name: 'Tests & Documentation',
    startDate: 'Avr 2026',
    finishDate: 'Mai 2026',
    progress: 85.0,
    status: 'in_progress',
  ),
];

final milestonesList = [
  const MilestoneItem(
    title: 'Lancement du projet',
    date: 'Sept 2025',
    description: 'Définition du cadrage et analyse des besoins',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Pipeline fonctionnel',
    date: 'Oct 2025',
    description: 'Pipeline Python de base opérationnel',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Calibration HSV',
    date: 'Nov 2025',
    description: 'Calibration sur 8 cartes militaires réelles',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Modèle IA entraîné',
    date: 'Déc 2025',
    description: 'U-Net ResNet34 entraîné sur SEMAP (13,561 échantillons)',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Agent IA opérationnel',
    date: 'Jan 2026',
    description: 'Agent LangGraph avec boucle Perceive→Plan→Execute→QA',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Détection cadre OK',
    date: 'Fév 2026',
    description: 'Algorithme two-stage testé sur 8 cartes réelles',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Web App déployée',
    date: 'Mars 2026',
    description: 'Backend Django REST + Frontend React/Vite opérationnels',
    isCompleted: true,
  ),
  const MilestoneItem(
    title: 'Soutenance PFA',
    date: 'Mai 2026',
    description: 'Présentation finale et livraison du projet',
    isCompleted: false,
  ),
];

final architectureSteps = [
  const ArchitectureStep(
    title: 'Prétraitement',
    description: "Chargement et préparation de l'image raster",
    icon: '📥',
    details: [
      'Détection automatique du cadre (neatline)',
      'Suppression de la légende interne (Stage 2)',
      'Redimensionnement adaptatif (max 2400px)',
      'Débruitage et amélioration du contraste',
    ],
  ),
  const ArchitectureStep(
    title: 'Segmentation Couleur',
    description: 'Extraction des couches par plages HSV',
    icon: '🎨',
    details: [
      'Routes rouges (H=0-15, S≥60)',
      'Végétation verte (H=35-95, S≥20)',
      'Eau bleue (H=95-145)',
      'Courbes de niveau brunes (H=6-25)',
      'Bâtiments gris foncé (V=30-130)',
    ],
  ),
  const ArchitectureStep(
    title: 'Segmentation IA',
    description: 'Inférence U-Net pour segmentation sémantique',
    icon: '🧠',
    details: [
      'U-Net ResNet34 avec SMP',
      '6 classes SEMAP (background, contours, built, non_built, water, road_network)',
      'Support GPU/CPU automatique',
      'Fallback vers segmentation couleur si indisponible',
    ],
  ),
  const ArchitectureStep(
    title: 'Post-traitement',
    description: 'Nettoyage et vectorisation des masques',
    icon: '🔧',
    details: [
      'Connected Components (CC) labeling',
      'Filtrage morphologique (ouverture/fermeture)',
      'Squelettisation pour lignes (routes, courbes)',
      'Simplification Douglas-Peucker',
    ],
  ),
  const ArchitectureStep(
    title: 'Géoréférencement',
    description: 'Attribution de coordonnées géographiques',
    icon: '🌍',
    details: [
      'Détection du quadrillage cartographique',
      'Génération automatique de GCPs',
      'Transformation affine (moindres carrés)',
      'Export World File (.pgw/.tfw)',
    ],
  ),
  const ArchitectureStep(
    title: 'Export & Visualisation',
    description: 'Production des livrables finaux',
    icon: '📤',
    details: [
      'Export GeoJSON par couche',
      'Export Shapefile (ESRI)',
      'Visualisation Leaflet interactive',
      'Correction humaine (HITL) avec Geoman',
    ],
  ),
];

final timelineEvents = [
  const TimelineEvent(
    date: 'Septembre 2025',
    title: 'Lancement du projet',
    description: 'Définition du cadrage, analyse des besoins, choix technologiques. Étude des datasets SODUCO et SEMAP.',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Octobre 2025',
    title: 'Pipeline de base',
    description: 'Développement du pipeline Python : prétraitement, segmentation HSV, vectorisation basique avec OpenCV et GeoPandas.',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Novembre 2025',
    title: 'Calibration HSV',
    description: 'Calibration des plages HSV sur 8 cartes militaires réelles (AMS/GSGS 1:50,000 Tunisie + Algérie). Amélioration nette de la détection.',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Décembre 2025',
    title: 'Segmentation IA',
    description: 'Intégration de U-Net (ResNet34) avec segmentation-models-pytorch. Entraînement sur SEMAP dataset (13,561 échantillons).',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Janvier 2026',
    title: 'Agent IA & Active Learning',
    description: "Développement de l'agent LangGraph avec boucle Perceive→Plan→Execute→QA. Mise en place de l'Active Learning adaptatif HSV.",
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Février 2026',
    title: 'Détection du cadre',
    description: 'Algorithme two-stage (neatline + légende) testé sur 8 cartes réelles. Méthodes A (séparateur sombre), B (luminosité), C (fallback).',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Mars 2026',
    title: 'Web Application',
    description: 'Développement backend Django REST + frontend React/Vite. Intégration Leaflet avec outils de correction interactive.',
    isCompleted: true,
    progress: 1.0,
  ),
  const TimelineEvent(
    date: 'Avril-Mai 2026',
    title: 'Tests & Documentation',
    description: 'Tests sur cartes réelles tunisiennes et algériennes. Rédaction de la documentation technique et du mémoire.',
    isCompleted: true,
    progress: 0.85,
  ),
];

final bibliographyEntries = [
  const BibliographyEntry(
    title: 'Semantic Segmentation Map Dataset (Semap)',
    authors: 'Petitpierre R., Gomez Donoso D., Kriesel B.',
    year: '2025',
    source: 'EPFL, Zenodo',
    url: 'https://doi.org/10.5281/zenodo.16164781',
    type: 'Dataset',
  ),
  const BibliographyEntry(
    title: 'Generalizable Multiscale Segmentation of Heterogeneous Map Collections',
    authors: 'Petitpierre R.',
    year: '2026',
    source: 'arXiv:2603.05037',
    url: 'https://doi.org/10.48550/arXiv.2603.05037',
    type: 'Article',
  ),
  const BibliographyEntry(
    title: 'Benchmark_historical_map_vectorization',
    authors: 'SODUCO (Sorbonne Université)',
    year: '2021',
    source: 'GitHub / BnF Gallica',
    url: 'https://github.com/soduco/Benchmark_historical_map_vectorization',
    type: 'Dataset',
  ),
  const BibliographyEntry(
    title: 'ICDAR 2021 Competition on Historical Map Segmentation',
    authors: 'Chazalon J., Carlinet E., Chen Y., et al.',
    year: '2021',
    source: 'arXiv:2105.13265',
    url: 'https://arxiv.org/abs/2105.13265',
    type: 'Competition',
  ),
  const BibliographyEntry(
    title: 'Segmentation Models PyTorch',
    authors: 'Pavel Iakubovskii',
    year: '2023',
    source: 'GitHub',
    url: 'https://github.com/qubvel/segmentation_models.pytorch',
    type: 'Library',
  ),
  const BibliographyEntry(
    title: 'LangGraph - Build agentic applications',
    authors: 'LangChain',
    year: '2024',
    source: 'Documentation officielle',
    url: 'https://langchain-ai.github.io/langgraph/',
    type: 'Documentation',
  ),
  const BibliographyEntry(
    title: 'OpenCV - Computer Vision Library',
    authors: 'Intel / OpenCV Team',
    year: '2024',
    source: 'opencv.org',
    url: 'https://opencv.org/',
    type: 'Library',
  ),
  const BibliographyEntry(
    title: 'GeoPandas - Python tools for geographic data',
    authors: 'GeoPandas Team',
    year: '2024',
    source: 'geopandas.org',
    url: 'https://geopandas.org/',
    type: 'Library',
  ),
];