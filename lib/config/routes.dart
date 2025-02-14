import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/role_selection_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );
      case '/role-selection':
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );
      case '/register':
        final role = settings.arguments as UserRole;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(role: role),
        );
      case '/verify-otp':
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(userId: userId),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
