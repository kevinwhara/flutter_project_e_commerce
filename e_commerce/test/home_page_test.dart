import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_ecommerce/data/dummy_data.dart';
import 'package:ui_ecommerce/main.dart';
import 'package:ui_ecommerce/widgets/home_app_bar.dart';
import 'package:ui_ecommerce/widgets/product_card.dart';

void main() {
  Future<void> loginToHome(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(emailField, 'user@mail.com');
    await tester.enterText(passwordField, 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
  }

  testWidgets('tap tab Cart di CurvedNavigationBar memindahkan PageView', (
    tester,
  ) async {
    await loginToHome(tester);

    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller!.page, closeTo(0.0, 0.01));

    final cartIcon = find.descendant(
      of: find.byType(CurvedNavigationBar),
      matching: find.byIcon(Icons.shopping_cart),
    );
    await tester.tap(cartIcon, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(pageView.controller!.page, closeTo(1.0, 0.01));

    final accountIcon = find.descendant(
      of: find.byType(CurvedNavigationBar),
      matching: find.byIcon(Icons.account_circle_sharp),
    );
    await tester.tap(accountIcon, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(pageView.controller!.page, closeTo(2.0, 0.01));
    expect(find.text('Account Placeholder'), findsOneWidget);
  });

  testWidgets('swipe PageView menyinkronkan index CurvedNavigationBar', (
    tester,
  ) async {
    await loginToHome(tester);

    // Fling dari HomeAppBar (bukan dari tengah PageView), supaya gesture
    // tidak dicuri oleh CategoriesWidget yang juga scroll horizontal.
    await tester.fling(find.byType(HomeAppBar), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.controller!.page, closeTo(1.0, 0.01));
  });

  testWidgets('tap produk berbeda menampilkan data produk yang sesuai', (
    tester,
  ) async {
    await loginToHome(tester);

    final cards = find.byType(ProductCard);
    expect(cards, findsNWidgets(dummyProducts.length));

    // Cuma gambar produk yang tappable (InkWell membungkus Image, bukan
    // nama/harga) — sesuai literal spec ProductCard.
    Future<void> tapProductImage(int index) async {
      final inkWell = find.descendant(
        of: cards.at(index),
        matching: find.byType(InkWell),
      );
      await tester.tap(inkWell);
      await tester.pumpAndSettle();
    }

    await tapProductImage(0);

    // Nama muncul 2x (judul AppBar + judul body) — tetap sah, keduanya
    // sama-sama menampilkan data produk yang sama.
    expect(find.text(dummyProducts[0].name), findsNWidgets(2));
    expect(
      find.text('\$${dummyProducts[0].price.toStringAsFixed(0)}'),
      findsOneWidget,
    );
    expect(find.text(dummyProducts[0].description), findsOneWidget);
    expect(find.text(dummyProducts[1].name), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Produk kedua — datanya harus beda, bukan selalu produk pertama.
    await tapProductImage(1);

    expect(find.text(dummyProducts[1].name), findsNWidgets(2));
    expect(
      find.text('\$${dummyProducts[1].price.toStringAsFixed(0)}'),
      findsOneWidget,
    );
    expect(find.text(dummyProducts[1].description), findsOneWidget);
    expect(find.text(dummyProducts[0].description), findsNothing);
  });
}
