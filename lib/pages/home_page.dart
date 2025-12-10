import 'package:flutter/material.dart';
import 'package:news_app/data/models/user.dart';
import 'package:news_app/data/service/auth_service.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:news_app/pages/login_page.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  String _todayDate() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final authService = AuthService(tokenStorage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: FutureBuilder<UserModel>(
        future: authService.getUser(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, ${user.name} 👋',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                Text(
                  'Hari ini: ${_todayDate()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () async {
                    await tokenStorage.clearToken();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPageView(),
                        ),
                      );
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
