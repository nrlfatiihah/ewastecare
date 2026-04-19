import 'package:cloud_firestore/cloud_firestore.dart';

class ChatConversationModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final Timestamp updatedAt;
  final Map<String, int> unreadCounts;

  ChatConversationModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
    required this.unreadCounts,
  });

  factory ChatConversationModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawUnread = data['unreadCounts'];

    final unreadCounts = <String, int>{};
    if (rawUnread is Map<String, dynamic>) {
      rawUnread.forEach((key, value) {
        if (value is num) unreadCounts[key] = value.toInt();
      });
    }

    return ChatConversationModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? const <String>[]),
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: data['updatedAt'] is Timestamp
          ? data['updatedAt'] as Timestamp
          : Timestamp.now(),
      unreadCounts: unreadCounts,
    );
  }

  int unreadFor(String userId) => unreadCounts[userId] ?? 0;
}
