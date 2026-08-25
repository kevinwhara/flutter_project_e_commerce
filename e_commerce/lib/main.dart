import 'package:flutter/material.dart';

import 'models/chat_preview.dart';
import 'pages/cart_page.dart';
import 'pages/detail_chat.dart';
import 'pages/home_page.dart';
import 'pages/list_chat.dart';
import 'pages/login_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Keranjang Rek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _borderColor,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: _bgColor,
        useMaterial3: true,
        // Neo Brutalism global text theme
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w600, color: _borderColor),
          bodyLarge: TextStyle(fontWeight: FontWeight.w600, color: _borderColor),
        ),
        // Snackbar styling
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _borderColor,
          contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: _borderColor, width: 2),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const Homepage(),
        '/cart': (context) => const CartPage(),
        '/product-detail': (context) => const ProductDetailPage(),
        '/chat-list': (context) => const ChatListPage(),
        '/chat-detail': (context) {
          final contact = ModalRoute.of(context)!.settings.arguments as ChatPreview;
          return ChatScreen(contact: contact);
        },
      },
    );
  }
}
