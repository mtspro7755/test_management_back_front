class Tache {
  final int id;
  final String titre;
  final String? description;
  final String statut;
  final String? dateEcheance;
  final int projet;
  final int? assignee;

  Tache({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.dateEcheance,
    required this.projet,
    this.assignee,
  });

  factory Tache.fromJson(Map<String, dynamic> json) {
    return Tache(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      statut: json['statut'],
      dateEcheance: json['date_echeance'],
      projet: json['projet'],
      assignee: json['assignee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'statut': statut,
      'date_echeance': dateEcheance,
      'projet': projet,
      'assignee': assignee,
    };
  }
}
