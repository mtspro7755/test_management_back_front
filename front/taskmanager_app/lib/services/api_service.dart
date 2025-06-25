import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/projet.dart';
import '../models/tache.dart';

class ApiService {
  //static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const String _baseUrl = 'http://127.0.0.1:8000/api';
  static const storage = FlutterSecureStorage();

  // 🔐 Auth (inchangé)
  static Future<http.Response> login(String username, String password) {
    return http.post(
      Uri.parse('$_baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
  }

  static Future<http.Response> register(String username, String email, String password) {
    return http.post(
      Uri.parse('$_baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );
  }

  // 📁 Projets

  static Future<List<Projet>> getProjets() async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$_baseUrl/projets/'),
      headers: _authHeader(token),
    );

    if (response.statusCode == 200) {
      return Projet.fromJsonList(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Non autorisé');
    } else {
      throw Exception('Erreur de chargement des projets');
    }
  }

  static Future<Projet> createProjet(Map<String, dynamic> body) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      Uri.parse('$_baseUrl/projets/'),
      headers: _authHeader(token),
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return Projet.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erreur de création de projet");
    }
  }

  static Future<Projet> updateProjet(int id, Map<String, dynamic> body) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.put(
      Uri.parse('$_baseUrl/projets/$id/'),
      headers: _authHeader(token),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Projet.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erreur de modification de projet");
    }
  }

  static Future<void> deleteProjet(int id) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/projets/$id/'),
      headers: _authHeader(token),
    );

    if (response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression");
    }
  }

  // 📝 Tâches

  static Future<Tache> createTache(Map<String, dynamic> body) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      Uri.parse('$_baseUrl/taches/'),
      headers: _authHeader(token),
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return Tache.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erreur lors de la création de la tâche");
    }
  }

  static Future<Tache> updateTache(int id, Map<String, dynamic> body) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.put(
      Uri.parse('$_baseUrl/taches/$id/'),
      headers: _authHeader(token),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Tache.fromJson(json.decode(response.body));
    } else {
      throw Exception("Erreur lors de la modification de la tâche");
    }
  }

  static Future<void> deleteTache(int id) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.delete(
      Uri.parse('$_baseUrl/taches/$id/'),
      headers: _authHeader(token),
    );

    if (response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de la tâche");
    }
  }

  static Future<List<Tache>> getTachesByProjet(int projetId) async {
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      Uri.parse('$_baseUrl/taches/?projet=$projetId'),
      headers: _authHeader(token),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Tache.fromJson(e)).toList();
    } else {
      throw Exception("Erreur de chargement des tâches");
    }
  }


  // 🛡️ Auth header helper
  static Map<String, String> _authHeader(String? token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
