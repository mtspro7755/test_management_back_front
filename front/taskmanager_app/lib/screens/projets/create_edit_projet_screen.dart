import 'package:flutter/material.dart';
import '../../models/projet.dart';
import '../../services/api_service.dart';

class CreateEditProjetScreen extends StatefulWidget {
  final Projet? projet;

  const CreateEditProjetScreen({super.key, this.projet});

  @override
  State<CreateEditProjetScreen> createState() => _CreateEditProjetScreenState();
}

class _CreateEditProjetScreenState extends State<CreateEditProjetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.projet?.nom ?? '');
    _descriptionController = TextEditingController(text: widget.projet?.description ?? '');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final body = {
      'nom': _nomController.text.trim(),
      'description': _descriptionController.text.trim(),
    };

    try {
      if (widget.projet == null) {
        await ApiService.createProjet(body);
      } else {
        await ApiService.updateProjet(widget.projet!.id, body);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.projet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier le projet" : "Créer un projet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du projet *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? "Mettre à jour" : "Créer"),
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
