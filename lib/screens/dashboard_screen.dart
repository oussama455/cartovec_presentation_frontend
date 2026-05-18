import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_data.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  
  // Futures for async backend calls
  late Future<List<dynamic>> _tasksFuture;
  late Future<List<dynamic>> _timelineFuture;
  late Future<List<dynamic>> _profilesFuture;

  @override
  void initState() {
    super.initState();
    _refreshAllData();
  }

  void _refreshAllData() {
    setState(() {
      _tasksFuture = _apiService.fetchTasks();
      _timelineFuture = _apiService.fetchTimeline();
      _profilesFuture = _apiService.fetchProfiles();
    });
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Gérer le profil"),
              onTap: () async {
                Navigator.pop(context);
                final profiles = await _profilesFuture;
                if (profiles.isNotEmpty) {
                  _showEditProfileDialog(profiles.first);
                } else {
                  _showCreateProfileDialog();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text("Ajouter une tâche"),
              onTap: () {
                Navigator.pop(context);
                _showAddTaskDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.timeline),
              title: const Text("Ajouter un jalon"),
              onTap: () {
                Navigator.pop(context);
                _showAddTimelineDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvelle Tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final success = await _apiService.createNewTask(titleController.text, descController.text);
                if (success) {
                  _refreshAllData();
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void _showAddTimelineDialog() {
    final titleController = TextEditingController();
    final dateRangeController = TextEditingController();
    final detailsController = TextEditingController();
    double progress = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Nouveau Jalon"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: "Titre")),
                TextField(controller: dateRangeController, decoration: const InputDecoration(labelText: "Période (ex: Oct 2025)")),
                TextField(controller: detailsController, decoration: const InputDecoration(labelText: "Détails")),
                const SizedBox(height: 16),
                Text("Progression: ${progress.toInt()}%"),
                Slider(
                  value: progress,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: (val) => setDialogState(() => progress = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final success = await _apiService.createTimelineEvent({
                    "title": titleController.text,
                    "date_range": dateRangeController.text,
                    "achievement_details": detailsController.text,
                    "progress_percentage": progress.toInt(),
                  });
                  if (success) {
                    _refreshAllData();
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProfileDialog() {
    final nameController = TextEditingController(text: userCardInfo.name);
    final roleController = TextEditingController(text: userCardInfo.role);
    final emailController = TextEditingController(text: projectInfo.email);
    final supervisorController = TextEditingController(text: projectInfo.supervisor);
    final descriptionController = TextEditingController(text: projectInfo.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Créer un Profil"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom complet")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: supervisorController, decoration: const InputDecoration(labelText: "Encadrant")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description du projet"), maxLines: 3),
              TextField(controller: roleController, decoration: const InputDecoration(labelText: "Rôle (Étudiant, etc.)")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              final success = await _apiService.createProfile({
                "full_name": nameController.text,
                "email": emailController.text,
                "supervisor": supervisorController.text,
                "project_description": descriptionController.text,
                "role": roleController.text,
                "bio": roleController.text, // Assuming Bio maps to something
              });
              if (success) {
                _refreshAllData();
                Navigator.pop(context);
              }
            },
            child: const Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(Map<String, dynamic> profile) {
    final nameController = TextEditingController(text: profile['full_name']);
    final emailController = TextEditingController(text: profile['email'] ?? '');
    final supervisorController = TextEditingController(text: profile['supervisor'] ?? '');
    final descriptionController = TextEditingController(text: profile['project_description'] ?? '');
    final roleController = TextEditingController(text: profile['role'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le Profil"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom complet")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: supervisorController, decoration: const InputDecoration(labelText: "Encadrant")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
              TextField(controller: roleController, decoration: const InputDecoration(labelText: "Rôle")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              final success = await _apiService.updateUserProfile(profile['id'], {
                "full_name": nameController.text,
                "email": emailController.text,
                "supervisor": supervisorController.text,
                "project_description": descriptionController.text,
                "role": roleController.text,
              });
              if (success) {
                _refreshAllData();
                Navigator.pop(context);
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      body: RefreshIndicator(
        onRefresh: () async => _refreshAllData(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFf39c12),
              actions: [
                IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _refreshAllData),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Dashboard', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFf39c12), Color(0xFFd68910)],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildDynamicUserCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Chronologie du Projet'),
                  const SizedBox(height: 16),
                  _buildDynamicTimelineBlock(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Gestion des Tâches'),
                  const SizedBox(height: 16),
                  _buildDynamicTasksTable(),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D6B78),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDynamicUserCard() {
    return FutureBuilder<List<dynamic>>(
      future: _profilesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildStaticUserCard(); // Fallback
        }

        final profile = snapshot.data!.first;
        return GestureDetector(
          onTap: () => _showEditProfileDialog(profile),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0d6b78), Color(0xFF084c57)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF0d6b78).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: Center(child: Text(profile['avatar'] ?? "👤", style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile['full_name'] ?? 'Utilisateur', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(profile['role'] ?? 'Étudiant en Géomatique', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(profile['email'] ?? '', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                      const SizedBox(height: 8),
                      Text('Encadrant: ${profile['supervisor'] ?? ''}', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.edit, color: Colors.white54, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaticUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0d6b78), Color(0xFF084c57)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("Connectez-vous à l'API pour voir le profil", style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(color: const Color(0xFF1e293b), fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  // --- PARSE LIVE CHRONOLOGY DATA FROM DJANGO ---
  Widget _buildDynamicTimelineBlock() {
    return FutureBuilder<List<dynamic>>(
      future: _timelineFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text("Aucun jalon d'historique disponible sur l'API.")),
          );
        }

        final timelineData = snapshot.data!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: List.generate(timelineData.length, (index) {
              final milestone = timelineData[index];
              final isLast = index == timelineData.length - 1;
              final isCompleted = milestone['progress_percentage'] == 100;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFF27ae60) : const Color(0xFFe2e8f0),
                            shape: BoxShape.circle,
                            border: Border.all(color: isCompleted ? const Color(0xFF27ae60) : const Color(0xFFcbd5e1), width: 2),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted ? const Color(0xFF27ae60).withOpacity(0.3) : const Color(0xFFe2e8f0),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  milestone['date_range'],
                                  style: GoogleFonts.inter(color: const Color(0xFF94a3b8), fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                                if (isCompleted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFdcfce7), borderRadius: BorderRadius.circular(4)),
                                    child: Text('✓', style: GoogleFonts.inter(color: const Color(0xFF166534), fontSize: 10)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              milestone['title'],
                              style: GoogleFonts.inter(color: const Color(0xFF1e293b), fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              milestone['achievement_details'],
                              style: GoogleFonts.inter(color: const Color(0xFF64748b), fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  // --- PARSE LIVE TASKS DATA FROM DJANGO ---
  Widget _buildDynamicTasksTable() {
    return FutureBuilder<List<dynamic>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text("Aucune tâche disponible sur l'API.")),
          );
        }

        final tasksData = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              // Table Header Structure
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: const Color(0xFFf1f5f9),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text('Tâche', style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('Description', style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Statut', textAlign: TextAlign.center, style: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // Table Rows rendering database fields dynamically
              ...tasksData.map((task) {
                final isLast = task == tasksData.last;
                final bool isCompleted = task['status'] == 'completed';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: isCompleted ? 1.0 : 0.4, // Set full fill or mid progress depending on step lifecycle status
                                minHeight: 4,
                                backgroundColor: const Color(0xFFe2e8f0),
                                valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? const Color(0xFF27ae60) : const Color(0xFFf39c12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            task['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(color: const Color(0xFF64748b), fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFFdcfce7) : const Color(0xFFfef3c7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task['status'].toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: isCompleted ? const Color(0xFF166534) : const Color(0xFF92400e),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}