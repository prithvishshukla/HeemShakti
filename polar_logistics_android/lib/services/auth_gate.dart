import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../screens/start_menu.dart';
import 'auth_service.dart';

const Color _polarVeryLight = Color(0xFFE3F2FD);
const Color _polarBlue = Color(0xFF2196F3);

// ============================================================
// AUTH GATE
// ------------------------------------------------------------
// Wraps every Admin-only or Expedition-only screen. This is the
// mechanism that stops role-based bypass by navigation: even if
// something tried to push AdminDashboard (or ManageExpeditionUsersPage)
// directly, AuthGate independently re-validates the current session
// and account status against UserRepository before ever building the
// protected content. Hiding buttons is not relied upon anywhere.
//
// Behaviour:
//   - No valid session, wrong role, or inactive account -> the
//     protected screen is never built; the user is redirected to
//     StartMenu with pushAndRemoveUntil, which also clears the
//     navigation stack so the back button cannot return to the
//     protected screen.
//   - Valid session -> the up-to-date AppUser record is handed to
//     [builder] so screens can render live data (name, role, etc.)
//     instead of stale session data.
// ============================================================
class AuthGate extends StatefulWidget {
  final UserRole requiredRole;
  final Widget Function(BuildContext context, AppUser user) builder;

  const AuthGate({
    super.key,
    required this.requiredRole,
    required this.builder,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<AppUser?> _future;

  @override
  void initState() {
    super.initState();
    _future =
        AuthService.instance.getValidatedUser(requiredRole: widget.requiredRole);
  }

  void _redirectToStartMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartMenu()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _AuthCheckingScaffold();
        }

        final user = snapshot.data;
        if (user == null) {
          _redirectToStartMenu();
          return const _AuthCheckingScaffold();
        }

        return widget.builder(context, user);
      },
    );
  }
}

class _AuthCheckingScaffold extends StatelessWidget {
  const _AuthCheckingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _polarVeryLight,
      body: Center(
        child: CircularProgressIndicator(color: _polarBlue),
      ),
    );
  }
}
