import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_ecommerce/data/dummy_data.dart';
import 'package:ui_ecommerce/models/chat_preview.dart';
import 'package:ui_ecommerce/pages/detail_chat.dart';
import 'package:ui_ecommerce/pages/list_chat.dart';

void main() {
  Future<void> pumpChatList(WidgetTester tester) async {
    // Reset isUnread tiap test: dummyChats objek shared top-level, mutasi
    // isUnread di satu test bisa bocor ke test lain kalau tidak direset.
    for (final chat in dummyChats) {
      chat.isUnread = chat.name == 'Nike Official' || chat.name == 'Budi Santoso';
    }

    await tester.pumpWidget(
      MaterialApp(
        home: const ChatListPage(),
        routes: {
          '/chat-detail': (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as ChatPreview;
            return ChatScreen(contact: contact);
          },
        },
      ),
    );
  }

  testWidgets('tap chat A menampilkan nama A di AppBar detail', (
    tester,
  ) async {
    await pumpChatList(tester);

    await tester.tap(find.text('Nike Official'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Nike Official')),
      findsOneWidget,
    );
  });

  testWidgets('badge merah hilang setelah chat dibuka, chat lain tidak ikut berubah', (
    tester,
  ) async {
    await pumpChatList(tester);

    // Awal: 2 badge unread (Nike Official, Budi Santoso).
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.text('Nike Official'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Cuma badge Nike Official yang hilang, Budi Santoso tetap ada.
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Budi Santoso')),
      findsOneWidget,
    );

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsNothing);
  });

  testWidgets('kirim pesan baru muncul di kanan warna orange.shade100', (
    tester,
  ) async {
    await pumpChatList(tester);

    await tester.tap(find.text('Adidas Store'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Halo, ini pesan tes');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    final bubbleText = find.text('Halo, ini pesan tes');
    expect(bubbleText, findsOneWidget);

    final align = tester.widget<Align>(
      find.ancestor(of: bubbleText, matching: find.byType(Align)).first,
    );
    expect(align.alignment, Alignment.centerRight);

    final bubbleContainer = tester.widget<Container>(
      find.ancestor(of: bubbleText, matching: find.byType(Container)).first,
    );
    final decoration = bubbleContainer.decoration as BoxDecoration;
    expect(decoration.color, Colors.orange.shade100);

    // Input dikosongkan lagi setelah kirim.
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
  });
}
