import 'package:fluentnow/app_router.dart';
import 'package:fluentnow/cache/cachehelper.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cache first
  await CacheData.initializeCache();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  runApp(FluentNow(appRouter: AppRouter()));
}

class FluentNow extends StatelessWidget {
  final AppRouter appRouter;

  const FluentNow({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: rootRoute, // Start at root for decision making
      navigatorKey: navigatorKey,
    );
  }
}
