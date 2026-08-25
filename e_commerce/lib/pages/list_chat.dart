import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/chat_preview.dart';

/// Neo Brutalism styled chat list page.
class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<ChatPreview> chats = dummyChats;

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _pink = Color(0xFFFF6B6B);
  static const _teal = Color(0xFF4ECDC4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _borderColor,
        title: const Text('List Chat 💬', style: TextStyle(fontWeight: FontWeight.w900, color: _borderColor)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _teal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor, width: 2),
            ),
            child: const Icon(Icons.search_rounded, size: 22, color: _borderColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                _filterChip('Semua', _teal, true),
                const SizedBox(width: 8),
                _filterChip('Belum Dibaca', _pink, false),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _borderColor, width: 2.5),
                    boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.8), offset: const Offset(3, 3), blurRadius: 0)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _borderColor, width: 2.5),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(chat.avatarAsset),
                        radius: 24,
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                    ),
                    title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.w800, color: _borderColor)),
                    subtitle: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _borderColor.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(chat.time, style: TextStyle(color: _borderColor.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w700)),
                        if (chat.isUnread)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _pink,
                              shape: BoxShape.circle,
                              border: Border.all(color: _borderColor, width: 1.5),
                            ),
                            child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor, width: 2),
        boxShadow: active ? const [BoxShadow(color: _borderColor, offset: Offset(2, 2), blurRadius: 0)] : [],
      ),
      child: Text(label, style: TextStyle(color: _borderColor, fontWeight: active ? FontWeight.w800 : FontWeight.w600, fontSize: 13)),
    );
  }
}
