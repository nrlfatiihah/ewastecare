import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/chat/models/chat_conversation_model.dart';
import 'package:ewastecare/features/chat/models/chat_message_model.dart';
import 'package:ewastecare/features/chat/models/chat_user_model.dart';

class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _conversationId(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<String> createOrGetConversation({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final conversationId = _conversationId(currentUserId, otherUserId);
    final conversationRef = _db.collection('Conversations').doc(conversationId);

    final snapshot = await conversationRef.get();
    if (!snapshot.exists) {
      await conversationRef.set({
        'participants': [currentUserId, otherUserId],
        'lastMessage': '',
        'updatedAt': Timestamp.now(),
        'unreadCounts': {currentUserId: 0, otherUserId: 0},
      });
    }

    return conversationId;
  }

  Stream<List<ChatConversationModel>> streamConversations(
    String currentUserId,
  ) {
    return _db
        .collection('Conversations')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
          final conversations = snapshot.docs
              .map((doc) => ChatConversationModel.fromSnapshot(doc))
              .toList();

          conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return conversations;
        });
  }

  Stream<List<ChatMessageModel>> streamMessages(String conversationId) {
    return _db
        .collection('Conversations')
        .doc(conversationId)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessageModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = Timestamp.now();
    final conversationRef = _db.collection('Conversations').doc(conversationId);
    final messageRef = conversationRef.collection('Messages').doc();

    await _db.runTransaction((transaction) async {
      final conversationSnapshot = await transaction.get(conversationRef);
      final conversationData =
          conversationSnapshot.data() ?? <String, dynamic>{};
      final participants = List<String>.from(
        conversationData['participants'] ?? const <String>[],
      );
      if (participants.isEmpty) {
        participants.add(senderId);
        final parts = conversationId.split('_');
        if (parts.length == 2) {
          final possibleOther = parts.first == senderId
              ? parts.last
              : parts.first;
          if (possibleOther.isNotEmpty && possibleOther != senderId) {
            participants.add(possibleOther);
          }
        }
      }

      final rawUnread = conversationData['unreadCounts'];
      final unreadCounts = <String, int>{};
      if (rawUnread is Map<String, dynamic>) {
        rawUnread.forEach((key, value) {
          if (value is num) unreadCounts[key] = value.toInt();
        });
      }

      for (final participantId in participants) {
        if (participantId == senderId) {
          unreadCounts[participantId] = 0;
        } else {
          unreadCounts[participantId] = (unreadCounts[participantId] ?? 0) + 1;
        }
      }

      transaction.set(messageRef, {
        'senderId': senderId,
        'text': trimmed,
        'createdAt': now,
        'seenBy': [senderId],
        'isRead': false,
      });

      transaction.set(conversationRef, {
        'participants': participants,
        'lastMessage': trimmed,
        'updatedAt': now,
        'unreadCounts': unreadCounts,
      }, SetOptions(merge: true));
    });
  }

  Future<void> markConversationRead({
    required String conversationId,
    required String currentUserId,
  }) async {
    final conversationRef = _db.collection('Conversations').doc(conversationId);
    final conversationDoc = await conversationRef.get();
    if (!conversationDoc.exists) return;

    final data = conversationDoc.data() ?? <String, dynamic>{};
    final participants = List<String>.from(
      data['participants'] ?? const <String>[],
    );
    final otherUserId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    await conversationRef.set({
      'unreadCounts': {currentUserId: 0},
    }, SetOptions(merge: true));

    if (otherUserId.isEmpty) return;

    final unreadMessages = await conversationRef
        .collection('Messages')
        .where('senderId', isEqualTo: otherUserId)
        .where('isRead', isEqualTo: false)
        .limit(100)
        .get();

    if (unreadMessages.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'seenBy': FieldValue.arrayUnion([currentUserId]),
        'isRead': true,
      });
    }
    await batch.commit();
  }

  Future<void> deleteConversation({
    required String conversationId,
    required String currentUserId,
  }) async {
    final conversationRef = _db.collection('Conversations').doc(conversationId);
    final conversationDoc = await conversationRef.get();
    if (!conversationDoc.exists) return;

    final data = conversationDoc.data() ?? <String, dynamic>{};
    final participants = List<String>.from(
      data['participants'] ?? const <String>[],
    );
    if (!participants.contains(currentUserId)) return;

    while (true) {
      final messages = await conversationRef
          .collection('Messages')
          .limit(400)
          .get();

      if (messages.docs.isEmpty) break;

      final batch = _db.batch();
      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await conversationRef.delete();
  }

  Stream<List<ChatUserModel>> streamChatUsers(String currentUserId) {
    final controller = StreamController<List<ChatUserModel>>();

    List<ChatUserModel> users = <ChatUserModel>[];
    List<ChatUserModel> admins = <ChatUserModel>[];

    void emitCombined() {
      final byId = <String, ChatUserModel>{
        for (final user in users) user.id: user,
        for (final admin in admins) admin.id: admin,
      };

      final combined = byId.values.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      if (!controller.isClosed) {
        controller.add(combined);
      }
    }

    final usersSub = _db.collection('Users').snapshots().listen((snapshot) {
      users = snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => ChatUserModel.fromSnapshot(doc))
          .toList();
      emitCombined();
    }, onError: controller.addError);

    final adminsSub = _db.collection('Admins').snapshots().listen((snapshot) {
      admins = snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => ChatUserModel.fromSnapshot(doc))
          .toList();
      emitCombined();
    }, onError: controller.addError);

    controller.onCancel = () async {
      await usersSub.cancel();
      await adminsSub.cancel();
    };

    return controller.stream;
  }

  Future<String> fetchUserName(String userId) async {
    final userDoc = await _db.collection('Users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data() ?? <String, dynamic>{};
      final firstName = data['FirstName'] ?? '';
      final lastName = data['LastName'] ?? '';
      final username = data['Username'] ?? '';
      final fullName = ('$firstName $lastName').trim();

      if (fullName.isNotEmpty) return fullName;
      if ((username as String).isNotEmpty) return username;
    }

    final adminDoc = await _db.collection('Admins').doc(userId).get();
    if (adminDoc.exists) {
      final data = adminDoc.data() ?? <String, dynamic>{};
      final username = (data['Username'] ?? '').toString();
      if (username.isNotEmpty) return username;
    }

    return userId;
  }

  Future<String> fetchUserProfilePicture(String userId) async {
    final userDoc = await _db.collection('Users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data() ?? <String, dynamic>{};
      final image = (data['ProfilePicture'] ?? '').toString();
      if (image.isNotEmpty) return image;
    }

    final adminDoc = await _db.collection('Admins').doc(userId).get();
    if (adminDoc.exists) {
      final data = adminDoc.data() ?? <String, dynamic>{};
      final image = (data['ProfilePicture'] ?? '').toString();
      if (image.isNotEmpty) return image;
    }

    return '';
  }
}
