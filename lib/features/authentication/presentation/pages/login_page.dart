import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_sizes.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/widgets/app_loader.dart';
import 'package:fotolou/core/widgets/app_scaffold.dart';
import 'package:fotolou/features/authentication/presentation/states/auth_state.dart';
import 'package:fotolou/features/authentication/presentation/widgets/login_form.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.success && next.user != null) {
        context.goNamed(AppRoute.home.name);
      }

      if (next.status == AuthStatus.error && next.message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
      }
    });

    final authState = ref.watch(authControllerProvider);
    if (authState.status == AuthStatus.loading && authState.user != null) {
      return const AppScaffold(body: AppLoader());
    }

    return AppScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxFormWidth),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
