import 'package:flutter/material.dart';
import '../../models/projet.dart';
import '../../models/tache.dart';
import '../../services/api_service.dart';
import '../tache/create_edit_tache_screen.dart';
import '../tache/create_edit_tache_screen.dart';

class DetailProjetScreen extends StatefulWidget {
  final Projet projet;

  const DetailProjetScreen({super.key, required this.projet});

  @override
  State<DetailProjetScreen> createState() => _DetailProjetScreenState();
}

class _DetailProjetScreenState extends State<DetailProjetScreen> {
  List<Tache> taches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchTaches();
  }

  Future<void> fetchTaches() async {
    setState(() {
      _loading = true;
      taches = [];
    });

    try {
      final result = await ApiService.getTachesByProjet(widget.projet.id);
      setState(() {
        taches = result;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }

  Icon _iconStatut(String statut) {
    switch (statut) {
      case 'TODO':
        return const Icon(Icons.radio_button_unchecked, color: Colors.grey);
      case 'IN_PROGRESS':
        return const Icon(Icons.sync, color: Colors.orange);
      case 'DONE':
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const Icon(Icons.help_outline, color: Colors.black);
    }
  }

  Future<void> _confirmerSuppressionTache(int tacheId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Supprimer cette tâche ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Supprimer")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteTache(tacheId);
        fetchTaches();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tâche supprimée")),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la suppression")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.projet.nom)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projet.description ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Créé le : ${widget.projet.dateCreation.split('T').first}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 32),
            Text("Tâches :", style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: taches.isEmpty
                  ? const Text("Aucune tâche pour ce projet.")
                  : ListView.builder(
                itemCount: taches.length,
                itemBuilder: (context, index) {
                  final tache = taches[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: _iconStatut(tache.statut),
                      title: Text(tache.titre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tache.description != null)
                            Text(tache.description!),
                          if (tache.dateEcheance != null)
                            Text("Échéance : ${tache.dateEcheance!.split('T').first}"),
                          if (tache.assignee != null)
                            Text("Assigné à : #${tache.assignee}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateEditTacheScreen(
                                    tache: tache,
                                    projetId: widget.projet.id,
                                  ),
                                ),
                              );
                              if (updated == true) fetchTaches();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmerSuppressionTache(tache.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEditTacheScreen(projetId: widget.projet.id),
            ),
          );
          if (result == true) fetchTaches();
        },
        label: const Text("Ajouter"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
