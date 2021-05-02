import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_yzj/pages/signup/widget/log_in_reminder.dart';

void main() {
  testWidgets('log in reminder should show tips', (WidgetTester tester) async {
    await tester.pumpWidget(LogInReminder());
    final text1TipFinder = find.text("Already has account? ");
    final text2TipFinder = find.text("Log In");

    expect(text1TipFinder, findsOneWidget);
    expect(text2TipFinder, findsOneWidget);
  });
}
