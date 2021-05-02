// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('FYP App', () {
    // final buttonFinder = find.byValueKey('increment');
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    group("Weclome page", () {
      final logInButtonFinder = find.byValueKey("logInButton");
      final logInButtonTextFinder = find.byValueKey("logInButtonText");
      final signUpTipTextFinder = find.byValueKey("signUpTip");
      test('should show login button', () async {
        // 用 `driver.getText` 来判断 counter 初始化是 0
        expect(await driver.getText(logInButtonTextFinder), "Log In");
      });
      test('should show sign up tip', () async {
        // 用 `driver.getText` 来判断 counter 初始化是 0
        expect(await driver.getText(signUpTipTextFinder), "Sign up with email");
      });
    });
  });
}
