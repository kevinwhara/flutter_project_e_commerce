import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/chat_preview.dart';

/// Professional Mobile UI styled chat list page.
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<ChatPreview> chats = dummyChats;

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _accentPink = Color(0xFFFF6B6B);
  static const _surface = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _textDark,
        elevation: 0,
        title: const Text('List Chat', style: TextStyle(fontWeight: FontWeight.w700, color: _textDark)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search_rounded, size: 22, color: _textDark),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _surface,
            child: Row(
              children: [
                _filterChip('Semua', _primary, true),
                const SizedBox(width: 8),
                _filterChip('Belum Dibaca', _textLight, false),
              ],
            ),
          ),
          // Chat list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 4), blurRadius: 12),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(chat.avatarAsset),
                      radius: 26,
                      onBackgroundImageError: (exception, stackTrace) {},
                    ),
                    title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.w600, color: _textDark, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _textLight, fontWeight: FontWeight.w400)),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat.time, style: const TextStyle(color: _textLight, fontSize: 12, fontWeight: FontWeight.w500)),
                        if (chat.isUnread)
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: _accentPink,
                              shape: BoxShape.circle,
                            ),
                            child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(context, '/chat-detail', arguments: chat);
                      setState(() { chat.isUnread = false; });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, Color color, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? color.withOpacity(0.2) : _textLight.withOpacity(0.2), width: 1),
      ),
      child: Text(label, style: TextStyle(color: active ? color : _textLight, fontWeight: active ? FontWeight.w600 : FontWeight.w500, fontSize: 14)),
    );
  }
}
