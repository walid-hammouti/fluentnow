import 'package:fluentnow/cache/cachehelper.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _determineInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final initialRoute = snapshot.data ?? welcomeScreen;

        // Use pushReplacement to prevent going back
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(initialRoute);
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<String> _determineInitialRoute() async {
    // Check auth first
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) return homeNavigationScreen;

    // Then check welcome screen cache
    final welcomeShown =
        CacheData.getData(key: 'WelcomeScreen_complete') ?? false;
    if (!welcomeShown) {
      CacheData.setData(key: 'WelcomeScreen_complete', value: true);
      return welcomeScreen;
    }

    return signupScreen;
  }
}
