import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhgo/core/widgets/app_card.dart';

void main() {
  testWidgets('AppCard renders child and responds to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Test Card Content'),
          ),
        ),
      ),
    );

    // Verify child text is rendered
    expect(find.text('Test Card Content'), findsOneWidget);

    // Tap card and verify callback
    await tester.tap(find.text('Test Card Content'));
    await tester.pumpAndSettle();

    expect(tapped, true);
  });
}
