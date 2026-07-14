import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/core/widgets/app_button.dart';

void main() {
  testWidgets('constrains the action icon inside the button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppButton(
              label: 'Se connecter',
              icon: const Icon(Icons.login, size: 64),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(FittedBox)), const Size.square(18));
  });
}
