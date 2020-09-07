import 'package:flutter_test/flutter_test.dart';

import 'package:parking/main.dart';

void main() {
  testWidgets('Render MyApp', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
  });
}
