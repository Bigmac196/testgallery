// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photogal/main.dart'; // Replace with your app's main.dart location

void main() {
  testWidgets('Photo gallery app UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the Take Photo button is present.
    expect(find.text('Take Photo'), findsOneWidget);

    // Verify that the Reload Photos button is present.
    expect(find.text('Reload Photos'), findsOneWidget);

    // Tap the 'Take Photo' button.
    await tester.tap(find.text('Take Photo'));
    await tester.pump(); // Rebuild the widget tree.

    // Verify that no error occurs after tapping the button (this is a basic check).
    expect(find.text('Take Photo'), findsOneWidget);
  });
}
