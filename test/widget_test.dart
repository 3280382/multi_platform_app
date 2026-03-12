import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_platform_app/main.dart';

void main() {
  testWidgets('App should render without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Navigation should work', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the home screen is rendered
    expect(find.text('首页'), findsOneWidget);
  });
}
