import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_ecommerce/data/dummy_data.dart';
import 'package:ui_ecommerce/pages/cart_page.dart';
import 'package:ui_ecommerce/widgets/home_app_bar.dart';
import 'package:ui_ecommerce/widgets/product_card.dart';
import 'package:ui_ecommerce/main.dart';

void main() {
  group('Coupon code (Cart)', () {
    testWidgets('input kupon tersembunyi sampai "Add Coupon Code" ditekan', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CartPage()));

      expect(find.text('Masukkan kode kupon'), findsNothing);

      await tester.tap(find.text('Add Coupon Code'));
      await tester.pumpAndSettle();

      expect(find.text('Masukkan kode kupon'), findsOneWidget);
    });

    testWidgets('tombol Apply disabled saat kosong, aktif saat diisi', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CartPage()));

      await tester.tap(find.text('Add Coupon Code'));
      await tester.pumpAndSettle();

      ElevatedButton applyButton() =>
          tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Apply'));

      expect(applyButton().onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'DISKON10');
      await tester.pump();

      expect(applyButton().onPressed, isNotNull);
    });

    testWidgets('tekan Apply menampilkan SnackBar dengan kode yang benar', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CartPage()));

      await tester.tap(find.text('Add Coupon Code'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'DISKON10');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Apply'));
      await tester.pump();

      expect(find.text('Kupon DISKON10 diterapkan'), findsOneWidget);
    });
  });

  group('Search filter (Homepage)', () {
    Future<void> loginToHome(WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextFormField).first, 'user@mail.com');
      await tester.enterText(find.byType(TextFormField).last, 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
    }

    testWidgets('ketik nama produk cuma nampilin yang cocok', (tester) async {
      await loginToHome(tester);

      expect(find.byType(ProductCard), findsNWidgets(dummyProducts.length));

      await tester.enterText(find.byType(TextFormField), 'Denim');
      await tester.pumpAndSettle();

      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('Denim Jacket'), findsOneWidget);
      expect(find.text('Running Shoes'), findsNothing);
    });

    testWidgets('hapus teks search balikin semua produk', (tester) async {
      await loginToHome(tester);

      await tester.enterText(find.byType(TextFormField), 'Denim');
      await tester.pumpAndSettle();
      expect(find.byType(ProductCard), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();

      expect(find.byType(ProductCard), findsNWidgets(dummyProducts.length));
    });
  });

  group('Highlight tab aktif (CurvedNavigationBar)', () {
    Future<void> loginToHome(WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextFormField).first, 'user@mail.com');
      await tester.enterText(find.byType(TextFormField).last, 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
    }

    // CurvedNavigationBar merender icon tab aktif 2x (bump animasi +
    // slot tetap di row) — keduanya instance widget yang sama persis
    // (properti identik), jadi ambil salah satu saja.
    Icon iconInNavBar(WidgetTester tester, IconData icon) {
      return tester
          .widgetList<Icon>(
            find.descendant(
              of: find.byType(CurvedNavigationBar),
              matching: find.byIcon(icon),
            ),
          )
          .first;
    }

    testWidgets('tab aktif beda ukuran/opacity, sinkron lewat tap navbar', (
      tester,
    ) async {
      await loginToHome(tester);

      // Home aktif di awal.
      expect(iconInNavBar(tester, Icons.home).size, 34);
      expect(iconInNavBar(tester, Icons.home).color, Colors.white);
      expect(iconInNavBar(tester, Icons.shopping_cart).size, 30);
      expect(iconInNavBar(tester, Icons.shopping_cart).color, Colors.white70);

      final cartIcon = find.descendant(
        of: find.byType(CurvedNavigationBar),
        matching: find.byIcon(Icons.shopping_cart),
      );
      await tester.tap(cartIcon, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(iconInNavBar(tester, Icons.shopping_cart).size, 34);
      expect(iconInNavBar(tester, Icons.shopping_cart).color, Colors.white);
      expect(iconInNavBar(tester, Icons.home).size, 30);
      expect(iconInNavBar(tester, Icons.home).color, Colors.white70);
    });

    testWidgets('tab aktif sinkron lewat swipe PageView', (tester) async {
      await loginToHome(tester);

      await tester.fling(find.byType(HomeAppBar), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      expect(iconInNavBar(tester, Icons.shopping_cart).size, 34);
      expect(iconInNavBar(tester, Icons.home).size, 30);
    });
  });
}
