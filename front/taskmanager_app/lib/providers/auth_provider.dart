import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    final token = await _storage.read(key: 'access_token');
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _isAuthenticated = false;
    notifyListeners();
  }
}
