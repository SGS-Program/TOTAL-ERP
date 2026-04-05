import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales/Screens/HomeScreen/dashboard.dart';

void main() {
  testWidgets('SalesDashboard renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        child: const MaterialApp(
          home: SalesDashboard(),
        ),
      ),
    );
    // Just verify the widget tree builds without throwing
    expect(find.byType(SalesDashboard), findsOneWidget);
  });
}
