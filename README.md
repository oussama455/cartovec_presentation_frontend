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
    │   └── dashboard_screen.dart       # Chronologie & tâches (redesign dark)
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

### Dashboard (`DashboardScreen`) — ✨ Redesigné

Refonte complète en thème **dark navy** avec les mêmes données et fonctions qu'avant :

- **Carte de profil** — avatar gradient teal avec initiale, chips de métadonnées en indigo
- **Timeline verticale** — 8 jalons avec dots lumineux, lignes de connexion dégradées et badges `Terminé` / `En cours`
- **Tableau des tâches** — barres de progression gradient avec glow, badges % colorés (teal = terminé, amber = en cours), polices mono pour les dates

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

### Palette globale (écrans clairs)

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

### Palette Dashboard (thème dark)

| Token | Valeur | Usage |
|-------|--------|-------|
| `_bg` | `#0B1120` | Fond principal |
| `_surface` | `#111827` | App bar / header |
| `_card` | `#1A2336` | Cartes & conteneurs |
| `_border` | `#243047` | Séparateurs & bordures |
| `_teal` | `#0ECFB3` | Accent principal / tâches terminées |
| `_amber` | `#FFB547` | Accent warning / tâches en cours |
| `_indigo` | `#818CF8` | Chips de métadonnées |
| `_txtHi` | `#F0F4FF` | Texte primaire |
| `_txtLo` | `#8898B4` | Texte secondaire |
| Police titres | Space Grotesk | Google Fonts |
| Police corps | DM Sans | Google Fonts |
| Police mono | DM Mono | Google Fonts (dates, %) |

---

## Installation

### Prérequis

- Flutter SDK **3.35.6+**
- Dart SDK **3.9.0+**
- Android Studio ou VS Code avec l'extension Flutter

### Étapes

```bash
# 1. Cloner le dépôt
git clone https://github.com/oussama455/cartovec_presentation_frontend.git
cd cartovec_presentation_frontend

# 2. Basculer sur la branche back
git checkout back

# 3. Installer les dépendances
flutter pub get

# 4. Générer les fichiers de localisation
flutter gen-l10n

# 5. Lancer sur un émulateur ou appareil connecté
flutter run
```

> Pour l'émulateur Android, l'API backend est accessible via `10.0.2.2:8000` (alias de `localhost` dans l'émulateur).

---

## Dépendances

| Package | Version | Rôle |
|---------|---------|------|
| `flutter_localizations` | sdk | Internationalisation |
| `intl` | ^0.20.2 | Formatage i18n |
| `google_fonts` | ^6.1.0 | Polices Inter, Cairo, Space Grotesk, DM Sans, DM Mono |
| `percent_indicator` | ^4.2.3 | Indicateurs circulaires / linéaires |
| `url_launcher` | ^6.2.2 | Ouverture liens bibliographiques |
| `flutter_svg` | ^2.0.9 | Rendu SVG |
| `flutter_staggered_animations` | ^1.1.1 | Animations décalées |
| `lottie` | ^3.0.0 | Animations Lottie |
| `shimmer` | ^3.0.0 | Effet de chargement |
| `cupertino_icons` | ^1.0.6 | Icônes iOS |

> `Space Grotesk`, `DM Sans` et `DM Mono` sont fournis par le package `google_fonts` déjà présent — aucune dépendance supplémentaire n'est nécessaire.

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
