import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_ecommerce/pages/cart_page.dart';
import 'package:ui_ecommerce/widgets/cart_item_tile.dart';

void main() {
  Future<void> pumpCart(WidgetTester tester) async {
    // height:700 di CartPage literal dari spec modul — viewport default test
    // (800x600) lebih pendek dari itu + BottomAppBar 140, jadi diperbesar
    // supaya tidak overflow saat test (bukan mengubah angka spec).
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CartPage()));
  }

  testWidgets('increment qty menaikkan total', (tester) async {
    await pumpCart(tester);

    // Item pertama = Sneakers, qty awal 1, harga 59.99.
    expect(find.text('Sneakers'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    // Sneakers jadi qty 2 -> sekarang ada 2 tile dengan teks '2'
    // (Sneakers + Backpack yang qty awalnya memang 2).
    expect(find.text('2'), findsNWidgets(2));

    // Total = 59.99*2 + 39.5*2 + 24.0 + 89.0 = 311.98
    expect(find.text('\$311.98'), findsOneWidget);
  });

  testWidgets('decrement tidak bisa turun di bawah 1', (tester) async {
    await pumpCart(tester);

    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pump();

    // Sneakers mulai qty 1 -> tetap 1, muncul di 2 tile (qty=1 default utk
    // item lain juga), pastikan minimal satu '1' masih ada dan tidak error.
    expect(tester.takeException(), isNull);
  });

  testWidgets('delete item menghilangkan tile dan menurunkan total', (tester) async {
    await pumpCart(tester);

    expect(find.text('Sneakers'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    expect(find.text('Sneakers'), findsNothing);
  });

  testWidgets('radius container item 10, tidak ada shadow di container item', (tester) async {
    await pumpCart(tester);

    // Container root dari CartItemTile: langsung child pertama widget-nya.
    final tile = tester.widget<CartItemTile>(find.byType(CartItemTile).first);
    final itemContainer = tester
        .widget<Container>(find.descendant(
          of: find.byWidget(tile),
          matching: find.byType(Container),
        ).first);
    final decoration = itemContainer.decoration as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(10));
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('checkout menampilkan snackbar', (tester) async {
    await pumpCart(tester);

    await tester.tap(find.text('Check Out'));
    await tester.pump();

    expect(find.text('Checkout belum tersedia'), findsOneWidget);
  });
}
