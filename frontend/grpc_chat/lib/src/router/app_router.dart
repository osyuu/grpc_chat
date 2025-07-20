import 'package:go_router/go_router.dart';
import 'package:grpc_chat/my_home_page.dart';
import 'package:grpc_chat/src/router/not_found_screen.dart';

enum AppRoute {
  home,
}

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) {
          return const MyHomePage();
        }),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
