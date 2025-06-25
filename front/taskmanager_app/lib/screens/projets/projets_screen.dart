import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/projet.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import 'create_edit_projet_screen.dart';
import 'detail_projet_screen.dart';

class ProjetsScreen extends StatefulWidget {
  const ProjetsScreen({super.key});

  @override
  State<ProjetsScreen> createState() => _ProjetsScreenState();
}

class _ProjetsScreenState extends State<ProjetsScreen> {
  List<Projet> projets = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchProjets();
  }

  Future<void> fetchProjets() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      projets = await ApiService.getProjets();
    } catch (e) {
      _error = e.toString();
    }

    setState(() => _loading = false);
  }

  Future<void> _confirmerSuppression(int projetId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Supprimer ce projet ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteProjet(projetId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Projet supprimé')),
        );
        fetchProjets();
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Projets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      )
          : RefreshIndicator(
        onRefresh: fetchProjets,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: projets.length,
          itemBuilder: (context, index) {
            final projet = projets[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  projet.nom,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (projet.description != null)
                      Text(projet.description!),
                    const SizedBox(height: 6),
                    Text(
                      "Créé le : ${projet.dateCreation.split('T').first}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
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
                            builder: (_) => CreateEditProjetScreen(projet: projet),
                          ),
                        );
                        if (updated == true) fetchProjets();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmerSuppression(projet.id),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailProjetScreen(projet: projet),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEditProjetScreen()),
          );
          if (created == true) fetchProjets();
        },
        label: const Text("Ajouter"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
