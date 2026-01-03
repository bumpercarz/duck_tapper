import 'package:duck_tapper/main.dart';
import '../lib/screens/login_screen.dart';
import '../lib/screens/nav_screen.dart';
import '../lib/widgets/register_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets('Quack Widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DuckTapper());

    // I GIVE UP YOU WIN

    // Verify that the title has loaded.
    expect(find.byKey(const ValueKey('titleText')), findsOneWidget);

  });
}
