import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/storage/local_storage.dart';
import 'package:fotolou/features/authentication/presentation/widgets/login_form.dart';

class MemoryLocalStorage implements LocalStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<String?> getString(String key) async {
    return _values[key];
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> saveString(String key, String value) async {
    _values[key] = value;
  }
}

void main() {
  testWidgets('validates required login fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageProvider.overrideWithValue(MemoryLocalStorage()),
        ],
        child: const MaterialApp(home: Scaffold(body: LoginForm())),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text('L’email est requis.'), findsOneWidget);
    expect(find.text('Le mot de passe est requis.'), findsOneWidget);
  });
}
