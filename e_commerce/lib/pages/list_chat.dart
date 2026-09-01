import 'package:flutter/material.dart';
import '../models/chat_preview.dart';
import '../data/dummy_data.dart'; // added import

/// Modern Messenger UI for chat list.
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  static const _primary = Color(0xFF4C53A5);
  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Messages', style: TextStyle(color: _textDark, fontWeight: FontWeight.w800, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: _textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Online contacts horizontal list
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyChats.length,
              itemBuilder: (context, index) {
                final chat = dummyChats[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: _primary.withValues(alpha: 0.1),
                            backgroundImage: AssetImage(chat.avatarAsset),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: 14, height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4ECDC4),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(chat.name.split(' ').first, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          
          // Chat list
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: dummyChats.length,
                itemBuilder: (context, index) {
                  final chat = dummyChats[index];
                  final hasUnread = chat.isUnread;
                  
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, '/chat-detail', arguments: chat),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: _primary.withValues(alpha: 0.1),
                            backgroundImage: AssetImage(chat.avatarAsset),
                          ),
                          const SizedBox(width: 16),
                          
                          // Message content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(chat.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
                                    Text(chat.time, style: TextStyle(fontSize: 12, fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500, color: hasUnread ? _primary : _textLight)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                                          color: hasUnread ? _textDark : _textLight,
                                        ),
                                      ),
                                    ),
                                    if (hasUnread)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(colors: [Color(0xFF6B73FF), Color(0xFF4C53A5)]),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
