import 'dart:convert';
import 'tache.dart';

class Projet {
  final int id;
  final String nom;
  final String? description;
  final String dateCreation;
  final List<Tache> taches;

  Projet({
    required this.id,
    required this.nom,
    required this.description,
    required this.dateCreation,
    required this.taches,
  });

  factory Projet.fromJson(Map<String, dynamic> json) {
    return Projet(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      dateCreation: json['date_creation'],
      taches: (json['taches'] as List<dynamic>?)
          ?.map((e) => Tache.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'date_creation': dateCreation,
      'taches': taches.map((t) => t.toJson()).toList(),
    };
  }

  static List<Projet> fromJsonList(String body) {
    final List data = json.decode(body);
    return data.map((e) => Projet.fromJson(e)).toList();
  }
}
