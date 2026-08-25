import 'package:flutter/material.dart';

import '../models/chat_preview.dart';

/// Neo Brutalism styled chat detail screen.
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

  static const _borderColor = Color(0xFF1A1A2E);
  static const _bgColor = Color(0xFFFFF59D);
  static const _teal = Color(0xFF4ECDC4);
  static const _orange = Color(0xFFFFB74D);
  static const _purple = Color(0xFFAB47BC);
  static const _mintFill = Color(0xFFB2DFDB);
  static const _lavender = Color(0xFFD1C4E9);

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
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _borderColor,
        title: Text(widget.contact.name, style: const TextStyle(color: _borderColor, fontWeight: FontWeight.w900)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: _borderColor, height: 3.5),
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
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? _orange.withValues(alpha: 0.3) : _mintFill,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _borderColor, width: 2.5),
                            boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.7), offset: const Offset(3, 3), blurRadius: 0)],
                          ),
                          child: Text(
                            message['text'],
                            style: const TextStyle(fontSize: 15, color: _borderColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            message['time'],
                            style: TextStyle(fontSize: 11, color: _borderColor.withValues(alpha: 0.5), fontWeight: FontWeight.w700),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _borderColor, width: 3)),
            ),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: _borderColor.withValues(alpha: 0.8), offset: const Offset(3, 3), blurRadius: 0)],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: _borderColor),
                      decoration: InputDecoration(
                        hintText: 'Type a message... 💭',
                        hintStyle: TextStyle(fontWeight: FontWeight.w600, color: _borderColor.withValues(alpha: 0.4)),
                        filled: true, fillColor: _lavender.withValues(alpha: 0.3),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _borderColor, width: 2.5)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _borderColor, width: 2.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _teal, width: 2.5)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColor, width: 2.5),
                      boxShadow: const [BoxShadow(color: _borderColor, offset: Offset(3, 3), blurRadius: 0)],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
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
