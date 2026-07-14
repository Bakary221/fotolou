import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fotolou/core/storage/local_storage.dart';

class SecureLocalStorage implements LocalStorage {
  const SecureLocalStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveString(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getString(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> remove(String key) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> clear() {
    return _storage.deleteAll();
  }
}
