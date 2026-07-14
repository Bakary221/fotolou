import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/app/routes/app_router.dart';
import 'package:fotolou/core/dependency_injection/providers.dart';
import 'package:fotolou/core/storage/local_storage.dart';

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
  test('keeps the router stable while requesting an otp', () async {
    final container = ProviderContainer(
      overrides: [localStorageProvider.overrideWithValue(MemoryLocalStorage())],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    await container
        .read(authControllerProvider.notifier)
        .requestPhoneOtp(phone: '+221701234567');

    expect(container.read(appRouterProvider), same(router));
  });
}
