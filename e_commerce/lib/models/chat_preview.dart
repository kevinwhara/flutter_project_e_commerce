class ChatPreview {
  ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarAsset,
    this.isUnread = false,
  });

  final String name;
  final String lastMessage;
  final String time;
  final String avatarAsset;
  bool isUnread;
}
