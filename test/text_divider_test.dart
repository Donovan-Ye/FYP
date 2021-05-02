import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_yzj/widget/text_divider.dart';

void main() {
  testWidgets('text divider should show entered content on the middle',
      (WidgetTester tester) async {
    await tester.pumpWidget(TextDivider(content: "test"));
    final contentTipFinder = find.text("test");

    expect(contentTipFinder, findsOneWidget);
  });
}
