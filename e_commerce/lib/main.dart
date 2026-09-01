import 'package:flutter/material.dart';

import 'models/chat_preview.dart';
import 'pages/address_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/detail_chat.dart';
import 'pages/favorite_page.dart';
import 'pages/help_center_page.dart';
import 'pages/home_page.dart';
import 'pages/list_chat.dart';
import 'pages/login_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/order_detail_page.dart';
import 'pages/order_history_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/register_page.dart';
import 'pages/notification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _primaryColor = Color(0xFF4C53A5);
  static const _bgColor = Color(0xFFF8F9FA);
  static const _borderColor = Color(0xFF1A1A2E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Keranjang Rek',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          primary: _primaryColor,
          surface: Colors.white,
          background: _bgColor,
        ),
        scaffoldBackgroundColor: _bgColor,
        useMaterial3: true,
        // Professional Mobile UI global text theme
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3142)),
          bodyLarge: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3142)),
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
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
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
        '/order-history': (context) => const OrderHistoryPage(),
        '/address': (context) => const AddressPage(),
        '/help-center': (context) => const HelpCenterPage(),
        '/favorite': (context) => const FavoritePage(),
        '/checkout': (context) => const CheckoutPage(),
        '/order-detail': (context) => const OrderDetailPage(),
        '/notification': (context) => const NotificationPage(),
      },
    );
  }
}
