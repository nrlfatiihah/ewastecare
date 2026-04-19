import 'package:ewastecare/features/chat/models/chat_conversation_model.dart';
import 'package:ewastecare/features/chat/models/chat_message_model.dart';
import 'package:ewastecare/features/chat/models/chat_user_model.dart';
import 'package:ewastecare/features/chat/repositories/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();

  final ChatRepository _repository = ChatRepository();
  final messageController = TextEditingController();
  final Set<String> _readInProgress = <String>{};

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<List<ChatConversationModel>> conversationsStream() {
    if (currentUserId.isEmpty) return const Stream.empty();
    return _repository.streamConversations(currentUserId);
  }

  Stream<List<ChatUserModel>> usersStream() {
    if (currentUserId.isEmpty) return const Stream.empty();
    return _repository.streamChatUsers(currentUserId);
  }

  Stream<List<ChatMessageModel>> messagesStream(String conversationId) {
    return _repository.streamMessages(conversationId);
  }

  Future<String> startConversation(String otherUserId) async {
    return _repository.createOrGetConversation(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  Future<void> sendMessage(String conversationId) async {
    final text = messageController.text;
    messageController.clear();
    await _repository.sendMessage(
      conversationId: conversationId,
      senderId: currentUserId,
      text: text,
    );
  }

  Future<void> markConversationAsRead(String conversationId) async {
    if (currentUserId.isEmpty || _readInProgress.contains(conversationId)) {
      return;
    }

    _readInProgress.add(conversationId);
    try {
      await _repository.markConversationRead(
        conversationId: conversationId,
        currentUserId: currentUserId,
      );
    } finally {
      _readInProgress.remove(conversationId);
    }
  }

  String otherParticipantId(ChatConversationModel conversation) {
    return conversation.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  Future<String> resolveUserName(String userId) {
    if (userId.isEmpty) return Future.value('');
    return _repository.fetchUserName(userId);
  }

  Future<String> resolveUserProfilePicture(String userId) {
    if (userId.isEmpty) return Future.value('');
    return _repository.fetchUserProfilePicture(userId);
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
