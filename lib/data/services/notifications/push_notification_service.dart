import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/chat/screens/chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class PushNotificationService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenSubscription;

  Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    _authStateSubscription?.cancel();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) {
      if (user == null) return;
      _syncCurrentToken(user.uid);
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _syncCurrentToken(currentUser.uid);
    }

    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      _upsertTokenForUser(uid: user.uid, token: token);
    });

    _messageOpenSubscription?.cancel();
    _messageOpenSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleChatNavigation,
    );
  }

  Future<void> handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      _handleChatNavigation(message);
    }
  }

  Future<void> _syncCurrentToken(String uid) async {
    final token = await _messaging.getToken();
    if (token == null || token.trim().isEmpty) return;

    await _upsertTokenForUser(uid: uid, token: token);
  }

  Future<void> _upsertTokenForUser({
    required String uid,
    required String token,
  }) async {
    final usersRef = _db.collection('Users').doc(uid);
    final adminsRef = _db.collection('Admins').doc(uid);

    final snapshots = await Future.wait([usersRef.get(), adminsRef.get()]);
    final writes = <Future<void>>[];

    if (snapshots[0].exists) {
      writes.add(
        usersRef.set({
          'FcmTokens': FieldValue.arrayUnion([token]),
        }, SetOptions(merge: true)),
      );
    }

    if (snapshots[1].exists) {
      writes.add(
        adminsRef.set({
          'FcmTokens': FieldValue.arrayUnion([token]),
        }, SetOptions(merge: true)),
      );
    }

    if (writes.isNotEmpty) {
      await Future.wait(writes);
    }
  }

  void _handleChatNavigation(RemoteMessage message) {
    final data = message.data;
    if ((data['type'] ?? '').toString() != 'chat') return;

    final conversationId = (data['conversationId'] ?? '').toString();
    final otherUserId = (data['senderId'] ?? '').toString();
    if (conversationId.isEmpty || otherUserId.isEmpty) return;

    final displayName =
        (message.notification?.title ?? data['senderName'] ?? 'User')
            .toString();

    Get.to(
      () => ChatRoomScreen(
        conversationId: conversationId,
        otherUserId: otherUserId,
        otherUserName: displayName,
      ),
    );
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    _messageOpenSubscription?.cancel();
    super.onClose();
  }
}
