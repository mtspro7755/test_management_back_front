import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<String> _checkAuth() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    return token != null ? '/projets' : '/';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Redirection automatique
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, snapshot.data!);
        });

        return const SizedBox.shrink(); // écran vide temporaire
      },
    );
  }
}
