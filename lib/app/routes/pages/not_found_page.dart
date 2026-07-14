import 'package:flutter/material.dart';
import 'package:fotolou/core/widgets/app_error_view.dart';
import 'package:fotolou/core/widgets/app_scaffold.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Page introuvable',
      body: AppErrorView(message: 'La page demandée n’existe pas.'),
    );
  }
}
