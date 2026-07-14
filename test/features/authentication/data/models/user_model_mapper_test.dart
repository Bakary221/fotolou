import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/features/authentication/data/models/user_model.dart';
import 'package:fotolou/features/authentication/domain/entities/user_role.dart';

void main() {
  test('maps UserModel to UserEntity', () {
    final model = UserModel(
      id: 'usr_1',
      email: 'user@example.com',
      name: 'User',
      role: UserRole.barber,
      createdAt: DateTime.utc(2026),
    );

    final entity = model.toEntity();

    expect(entity.id, model.id);
    expect(entity.email, model.email);
    expect(entity.name, model.name);
    expect(entity.role, model.role);
    expect(entity.createdAt, model.createdAt);
  });

  test('serializes and deserializes UserModel', () {
    final model = UserModel(
      id: 'usr_1',
      email: 'user@example.com',
      name: 'User',
      role: UserRole.barber,
      createdAt: DateTime.utc(2026),
    );

    final json = model.toJson();
    final restored = UserModel.fromJson(json);

    expect(restored.id, model.id);
    expect(restored.email, model.email);
    expect(restored.name, model.name);
    expect(restored.role, model.role);
    expect(restored.createdAt, model.createdAt);
  });
}
