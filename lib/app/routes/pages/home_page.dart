import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/widgets/app_empty_view.dart';
import 'package:fotolou/core/widgets/app_scaffold.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return AppScaffold(
      title: 'Fotolou',
      actions: [
        IconButton(
          tooltip: 'Déconnexion',
          onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
        ),
      ],
      body: user == null
          ? const AppEmptyView(message: 'Aucune session active.')
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour ${user.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(user.email),
                ],
              ),
            ),
    );
  }
}
