import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String senderId;
  final String text;
  final Timestamp createdAt;
  final List<String> seenBy;
  final bool isRead;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.seenBy,
    required this.isRead,
  });

  factory ChatMessageModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ChatMessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
          : Timestamp.now(),
      seenBy: List<String>.from(data['seenBy'] ?? const <String>[]),
      isRead: data['isRead'] == true,
    );
  }

  bool seenByUser(String userId) => seenBy.contains(userId);
}
