import 'package:flutter/material.dart';
import '../../models/tache.dart';
import '../../services/api_service.dart';

class CreateEditTacheScreen extends StatefulWidget {
  final Tache? tache;
  final int projetId;

  const CreateEditTacheScreen({
    super.key,
    this.tache,
    required this.projetId,
  });

  @override
  State<CreateEditTacheScreen> createState() => _CreateEditTacheScreenState();
}

class _CreateEditTacheScreenState extends State<CreateEditTacheScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _descriptionController;
  String _statut = 'TODO';
  DateTime? _dateEcheance;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.tache?.titre ?? '');
    _descriptionController = TextEditingController(text: widget.tache?.description ?? '');
    _statut = widget.tache?.statut ?? 'TODO';
    _dateEcheance = widget.tache?.dateEcheance != null
        ? DateTime.tryParse(widget.tache!.dateEcheance!)
        : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateEcheance ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _dateEcheance = date);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final body = {
      'titre': _titreController.text,
      'description': _descriptionController.text,
      'statut': _statut,
      'date_echeance': _dateEcheance?.toIso8601String().substring(0, 10),
      'projet': widget.projetId,
    };

    try {
      if (widget.tache == null) {
        await ApiService.createTache(body);
      } else {
        await ApiService.updateTache(widget.tache!.id, body);
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
    final isEditing = widget.tache != null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier Tâche" : "Nouvelle Tâche"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titreController,
                    decoration: const InputDecoration(
                      labelText: 'Titre *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _statut,
                    decoration: const InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'TODO', child: Text('À faire')),
                      DropdownMenuItem(value: 'IN_PROGRESS', child: Text('En cours')),
                      DropdownMenuItem(value: 'DONE', child: Text('Terminée')),
                    ],
                    onChanged: (val) => setState(() => _statut = val!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateEcheance == null
                              ? "Date : non définie"
                              : "Échéance : ${_dateEcheance!.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: const Text("Choisir la date"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? "Mettre à jour" : "Créer la tâche"),
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
