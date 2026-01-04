import 'package:duck_tapper/main.dart';
import '../lib/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Quack Widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DuckTapper());

    // Verify that the title (Quacky Tapper) has loaded.
    expect(find.byKey(const ValueKey('titleText')), findsOneWidget);

  });

  // Provider used to be initialized INSIDE the widget build and not during the initialization of the screen,
  // leading to an error that called another build() while the app was already building
  // Solution: Move provider variable to only be used by buttons that need it, and the first fetchAccounts
  // will be done within the initState instead 
  testWidgets('AccountProvider is initialized', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AccountProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(),
          ),
        ),
      ),
    );

    // Read provider from the test context
    final context = tester.element(find.byType(SizedBox));
    final provider = context.read<AccountProvider>();

    expect(provider, isNotNull);
  });

  testWidgets('AccountProvider starts with empty state', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AccountProvider(),
      child: const MaterialApp(
        home: Scaffold(body: SizedBox()),
      ),
    ),
  );

  final context = tester.element(find.byType(SizedBox));
  final provider = context.read<AccountProvider>();

  expect(provider.accounts, isEmpty);
  expect(provider.isLoading, isFalse);
  expect(provider.errorMessage, isNull);
});
}
