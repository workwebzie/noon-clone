import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:noon_clone/main.dart';
import 'package:noon_clone/providers/app_provider.dart';

void main() {
  testWidgets('NoonApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const NoonApp(),
      ),
    );
    expect(find.text('noon'), findsWidgets);
  });
}
