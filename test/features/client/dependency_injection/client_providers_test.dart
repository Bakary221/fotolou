import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/features/client/dependency_injection/client_providers.dart';

void main() {
  test('exposes immutable nearby salons and resolves one by id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final salons = container.read(nearbySalonsProvider);

    expect(salons, hasLength(4));
    expect(salons.first.name, 'King Barber');
    expect(container.read(salonByIdProvider(salons.first.id)), salons.first);
    expect(container.read(salonByIdProvider('unknown')), isNull);
    expect(() => salons.add(salons.first), throwsUnsupportedError);
  });
}
