import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_ecommerce/main.dart';

void main() {
  testWidgets('app membuka LoginPage sebagai initial route', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('submit kosong memunculkan error dan tidak navigasi', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong'), findsOneWidget);
    expect(find.text('Home Placeholder'), findsNothing);

    await tester.tap(find.widgetWithText(TextButton, "Don't have an account? Sign Up"));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong'), findsOneWidget);
    expect(find.text('Konfirmasi password tidak boleh kosong'), findsOneWidget);
    expect(find.text('Registrasi berhasil'), findsNothing);
  });

  testWidgets('email rusak ditolak, email valid lolos ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    for (final bad in ['test', 'test@', 'test@a']) {
      await tester.enterText(emailField, bad);
      await tester.enterText(passwordField, 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Home Placeholder'), findsNothing, reason: 'ditolak: $bad');
      expect(find.text('Format email tidak valid'), findsOneWidget, reason: 'ditolak: $bad');
    }

    await tester.enterText(emailField, 'user@mail.com');
    await tester.enterText(passwordField, 'secret123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Home bukan lagi placeholder teks — cek app bar + tab bar Homepage.
    expect(find.text('EcoGlobal'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsNothing);
  });

  testWidgets('confirm password beda ditolak', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(TextButton, "Don't have an account? Sign Up"));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Budi');
    await tester.enterText(fields.at(1), 'budi@mail.com');
    await tester.enterText(fields.at(2), 'secret123');
    await tester.enterText(fields.at(3), 'secret999');
    await tester.pumpAndSettle();

    expect(find.text('Password tidak sama'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();
    expect(find.text('Registrasi berhasil'), findsNothing);

    // Perbaiki Confirm supaya sama -> error hilang tanpa submit ulang.
    await tester.enterText(fields.at(3), 'secret123');
    await tester.pumpAndSettle();
    expect(find.text('Password tidak sama'), findsNothing);
  });

  testWidgets('register valid menampilkan snackbar lalu ke Login', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(TextButton, "Don't have an account? Sign Up"));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Budi');
    await tester.enterText(fields.at(1), 'budi@mail.com');
    await tester.enterText(fields.at(2), 'secret123');
    await tester.enterText(fields.at(3), 'secret123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();

    expect(find.text('Registrasi berhasil'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Home Placeholder'), findsNothing);
  });

  testWidgets('toggle show/hide password tidak menghilangkan isi field', (tester) async {
    await tester.pumpWidget(const MyApp());

    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(passwordField, 'secret123');

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    expect(tester.widget<TextFormField>(passwordField).controller!.text, 'secret123');
  });
}
