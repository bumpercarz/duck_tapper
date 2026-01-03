// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:duck_tapper/main.dart';
import 'package:duck_tapper/screens/duck_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Quack Widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DuckTapper());

    // Verify that the title has loaded.
    expect(find.text('Ducky Quacker'), findsOneWidget);

    // Verify that the buttons work.
    expect(find.byType(ElevatedButton).first.hitTestable(), findsOneWidget);
  });
}
