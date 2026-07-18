import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain layers do not depend on data, presentation, or Flutter', () {
    final violations = <String>[];
    final domainFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') && file.path.contains('/domain/'),
        );

    for (final file in domainFiles) {
      final source = file.readAsStringSync();
      const forbiddenImports = ['package:flutter/', '/data/', '/presentation/'];

      for (final forbiddenImport in forbiddenImports) {
        if (source.contains(forbiddenImport)) {
          violations.add('${file.path}: $forbiddenImport');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('core does not depend on feature implementations', () {
    final violations = <String>[];
    final coreFiles = Directory('lib/core')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in coreFiles) {
      if (file.readAsStringSync().contains('package:fotolou/features/')) {
        violations.add(file.path);
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
