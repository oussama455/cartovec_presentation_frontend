# CartoVec — Application Flutter de Présentation

> Application mobile de présentation du projet de fin d'année **CartoVec** — Vectorisation Automatique de Cartes Historiques  
> **Étudiant :** Oussama CHOUAIBI · **Encadrant :** Kamel BENRAIS (ELFOULADH) · **École :** EABA Tunisie

---

## Table des matières

1. [Présentation](#présentation)
2. [Structure du projet](#structure-du-projet)
3. [Pages de l'application](#pages-de-lapplication)
4. [Internationalisation](#internationalisation)
5. [Design System](#design-system)
6. [Installation](#installation)
7. [Dépendances](#dépendances)
8. [Build & Déploiement](#build--déploiement)
9. [Auteur](#auteur)

---

## Présentation

`cartovec_presentation` est une application Flutter qui présente le projet CartoVec sous forme d'une interface mobile soignée. Elle couvre le contexte académique, la méthodologie technique (pipeline 6 étapes), les résultats obtenus et un dashboard de suivi de projet. L'application supporte le **français** et l'**arabe** (RTL complet).

---

## Structure du projet

```
oussama455-cartovec_presentation/
├── pubspec.yaml
├── l10n.yaml                           # Configuration i18n
├── android/                            # Projet Android natif
└── lib/
    ├── main.dart                       # Point d'entrée + gestion locale
    ├── l10n/
    │   ├── app_fr.arb                  # Traductions françaises (template)
    │   ├── app_ar.arb                  # Traductions arabes
    │   ├── app_localizations.dart      # Classe générée (ne pas modifier)
    │   ├── app_localizations_fr.dart   # Implémentation FR
    │   └── app_localizations_ar.dart   # Implémentation AR
    ├── models/
    │   └── project_data.dart           # Modèles + données statiques
    ├── screens/
    │   ├── welcome_screen.dart         # Écran d'accueil
    │   ├── context_screen.dart         # Contexte & objectifs
    │   ├── architecture_screen.dart    # Pipeline & stack technique
    │   ├── results_screen.dart         # Résultats & métriques
    │   └── dashboard_screen.dart       # Chronologie & tâches
    └── widgets/
        ├── bottom_nav_bar.dart         # Barre de navigation
        └── language_selector.dart      # Sélecteur de langue
```

---

## Pages de l'application

### Écran d'accueil (`WelcomeScreen`)
Écran de lancement avec dégradé teal, titre **CartoVec**, description du projet et bouton « Commencer ».

### Contexte (`ContextScreen`)
Présente la problématique, les objectifs et le contexte académique. Inclut la carte d'informations étudiant/encadrant et les chips de technologies.

### Méthodologie (`ArchitectureScreen`)
Pipeline de traitement en 6 étapes visualisé horizontalement, puis développé via des `ExpansionTile` détaillés. Affiche également le stack technique (Vision & IA / Géospatial / Web) et le flux de données Frontend → API → Pipeline → Output.

### Résultats (`ResultsScreen`)
Grille de métriques clés (mIoU ~0.65, 8 cartes, 6 classes SEMAP, 13 561 échantillons), liste des livrables (GeoJSON, Shapefile, World File, Web App) et fiche du dataset SEMAP.

### Dashboard (`DashboardScreen`)
Carte de profil étudiant, timeline verticale des 8 jalons avec indicateurs de complétion, et tableau de suivi des tâches avec barres de progression.

---

## Internationalisation

L'application supporte **2 langues** avec RTL automatique :

| Langue | Code | Direction |
|--------|------|-----------|
| 🇫🇷 Français | `fr` | LTR |
| 🇸🇦 Arabe | `ar` | RTL |

Le changement de langue est dynamique (sans redémarrage) via le widget `LanguageSelector` dans l'AppBar. Les polices s'adaptent automatiquement : **Inter** pour le français, **Cairo** pour l'arabe.

Pour régénérer les fichiers de localisation après modification d'un `.arb` :

```bash
flutter gen-l10n
```

---

## Design System

| Élément | Valeur |
|---------|--------|
| Couleur principale | `#0D6B78` (Teal) |
| Couleur accent | `#E74C3C` (Rouge) |
| Couleur succès | `#27AE60` (Vert) |
| Couleur warning | `#F39C12` (Orange) |
| Police (FR) | Inter (Google Fonts) |
| Police (AR) | Cairo (Google Fonts) |
| Style | Material 3 + Glassmorphism |
| Navigation | `BottomNavigationBar` animée |

---

## Installation

### Prérequis

- Flutter SDK **3.35.6+**
- Dart SDK **3.9.0+**
- Android Studio ou VS Code avec l'extension Flutter

### Étapes

```bash
# 1. Cloner le dépôt
git clone https://github.com/oussama455/cartovec_presentation.git
cd cartovec_presentation

# 2. Installer les dépendances
flutter pub get

# 3. Générer les fichiers de localisation
flutter gen-l10n

# 4. Lancer sur un émulateur ou appareil connecté
flutter run
```

> Pour l'émulateur Android, l'API backend est accessible via `10.0.2.2:8000` (alias de `localhost` dans l'émulateur).

---

## Dépendances

| Package | Version | Rôle |
|---------|---------|------|
| `flutter_localizations` | sdk | Internationalisation |
| `intl` | ^0.20.2 | Formatage i18n |
| `google_fonts` | ^6.1.0 | Polices Inter & Cairo |
| `percent_indicator` | ^4.2.3 | Indicateurs circulaires / linéaires |
| `url_launcher` | ^6.2.2 | Ouverture liens bibliographiques |
| `flutter_svg` | ^2.0.9 | Rendu SVG |
| `flutter_staggered_animations` | ^1.1.1 | Animations décalées |
| `lottie` | ^3.0.0 | Animations Lottie |
| `shimmer` | ^3.0.0 | Effet de chargement |
| `cupertino_icons` | ^1.0.6 | Icônes iOS |

---

## Build & Déploiement

```bash
# APK de debug
flutter build apk --debug

# APK de release (optimisé)
flutter build apk --release

# Bundle Android (Google Play)
flutter build appbundle
```

L'APK de release se trouve dans `build/app/outputs/flutter-apk/app-release.apk`.

---

## Auteur

**Oussama CHOUAIBI**  
Étudiant en Géomatique — EABA Tunisie  
Encadrant : Kamel BENRAIS (Ingénieur Principal, ELFOULADH)  
Contact : ochouaibi1919@gmail.com

---

*CartoVec © 2026 — Projet de Fin d'Année Géomatique*
