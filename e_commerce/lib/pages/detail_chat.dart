import 'package:flutter/material.dart';

import '../models/chat_preview.dart';

/// Professional Mobile UI styled chat detail screen.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.contact});

  final ChatPreview contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hallo', 'isMe': false, 'time': '12:55'},
    {'text': 'Ada yang bisa dibantu?', 'isMe': false, 'time': '13:00'},
  ];
  final TextEditingController _controller = TextEditingController();

  static const _textDark = Color(0xFF2D3142);
  static const _textLight = Color(0xFF9094A6);
  static const _bgLight = Color(0xFFF8F9FA);
  static const _primary = Color(0xFF4C53A5);
  static const _surface = Colors.white;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({'text': _controller.text, 'isMe': true, 'time': _formatCurrentTime()});
      });
      _controller.clear();
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _textDark,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.contact.avatarAsset),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Text(widget.contact.name, style: const TextStyle(color: _textDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isMe = message['isMe'] as bool;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? _primary : _surface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, 2), blurRadius: 8),
                            ],
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(fontSize: 15, color: isMe ? Colors.white : _textDark, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            message['time'],
                            style: const TextStyle(fontSize: 11, color: _textLight, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input bar
          Container(
            decoration: BoxDecoration(
              color: _surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), offset: const Offset(0, -4), blurRadius: 16),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _bgLight,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontWeight: FontWeight.w500, color: _textDark),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: _textLight),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: _primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
