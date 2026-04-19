import 'dart:async';

import 'package:ewastecare/features/chat/controllers/chat_controller.dart';
import 'package:ewastecare/features/chat/models/chat_conversation_model.dart';
import 'package:ewastecare/features/chat/screens/chat_room_screen.dart';
import 'package:ewastecare/features/chat/screens/new_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  static const Color _chatGreen = Color(0xFF2E7D32);
  static const Color _chatGreenSoft = Color(0xFFE8F5E9);

  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _namesCache = {};
  final Map<String, String> _profilePicturesCache = {};
  Timer? _searchDebounce;
  String _query = '';
  List<ChatConversationModel> _lastConversations = const [];
  bool _isPrimingMetadata = false;
  bool _hasPrimedMetadata = false;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(dateTime));
  }

  Future<void> _cacheNames(
    ChatController controller,
    List<ChatConversationModel> conversations,
  ) async {
    final idsToLoad = conversations
        .map((conversation) => controller.otherParticipantId(conversation))
        .where((id) => id.isNotEmpty && !_namesCache.containsKey(id))
        .toSet()
        .toList();

    if (idsToLoad.isEmpty) return;

    final entries = await Future.wait(
      idsToLoad.map((id) async {
        final results = await Future.wait<String>([
          controller.resolveUserName(id),
          controller.resolveUserProfilePicture(id),
        ]);
        final name = results[0];
        final profilePicture = results[1];
        return (
          id: id,
          name: name.isNotEmpty ? name : 'unknown_user'.tr,
          profilePicture: profilePicture,
        );
      }),
    );

    if (!mounted) return;

    setState(() {
      for (final entry in entries) {
        _namesCache[entry.id] = entry.name;
        _profilePicturesCache[entry.id] = entry.profilePicture;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Text('messages'.tr),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const NewChatScreen()),
        backgroundColor: _chatGreen,
        foregroundColor: Colors.white,
        child: const Icon(Iconsax.message_add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _chatGreen.withOpacity(0.08),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: StreamBuilder<List<ChatConversationModel>>(
          stream: controller.conversationsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final conversations =
                snapshot.data ?? const <ChatConversationModel>[];
            if (!identical(conversations, _lastConversations)) {
              _lastConversations = conversations;
              _cacheNames(controller, conversations);
            }

            if (!_hasPrimedMetadata &&
                !_isPrimingMetadata &&
                conversations.isNotEmpty) {
              _isPrimingMetadata = true;
              _cacheNames(controller, conversations).whenComplete(() {
                if (!mounted) return;
                setState(() {
                  _isPrimingMetadata = false;
                  _hasPrimedMetadata = true;
                });
              });
            }

            if (!_hasPrimedMetadata && conversations.isNotEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final query = _query.trim().toLowerCase();
            final filteredConversations = conversations.where((conversation) {
              if (query.isEmpty) return true;

              final otherUserId = controller.otherParticipantId(conversation);
              final userName = (_namesCache[otherUserId] ?? 'unknown_user'.tr)
                  .toLowerCase();
              final lastMessage = conversation.lastMessage.toLowerCase();
              return userName.contains(query) || lastMessage.contains(query);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _searchDebounce?.cancel();
                      _searchDebounce = Timer(
                        const Duration(milliseconds: 250),
                        () {
                          if (!mounted) return;
                          setState(() => _query = value);
                        },
                      );
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.search_normal),
                      prefixIconColor: _chatGreen,
                      hintText: 'search_chats'.tr,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredConversations.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                          itemCount: filteredConversations.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final conversation = filteredConversations[index];
                            final otherUserId = controller.otherParticipantId(
                              conversation,
                            );
                            final userName =
                                _namesCache[otherUserId] ?? 'unknown_user'.tr;
                            final profilePicture =
                                _profilePicturesCache[otherUserId] ?? '';
                            final unreadCount = conversation.unreadFor(
                              controller.currentUserId,
                            );

                            return _ConversationCard(
                              name: userName,
                              lastMessage: conversation.lastMessage.isNotEmpty
                                  ? conversation.lastMessage
                                  : 'start_conversation'.tr,
                              profileImageUrl: profilePicture,
                              timeLabel: _formatTime(
                                context,
                                conversation.updatedAt.toDate(),
                              ),
                              unreadCount: unreadCount,
                              onTap: () => Get.to(
                                () => ChatRoomScreen(
                                  conversationId: conversation.id,
                                  otherUserId: otherUserId,
                                  otherUserName: userName,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _chatGreenSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 36,
                color: _chatGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'no_matching_chats'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'search_chats'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  static const Color _chatGreen = Color(0xFF2E7D32);
  static const Color _chatGreenSoft = Color(0xFFE8F5E9);

  const _ConversationCard({
    required this.name,
    required this.lastMessage,
    required this.profileImageUrl,
    required this.timeLabel,
    required this.unreadCount,
    required this.onTap,
  });

  final String name;
  final String lastMessage;
  final String profileImageUrl;
  final String timeLabel;
  final int unreadCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _chatGreen.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            profileImageUrl.trim().isNotEmpty
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: _chatGreenSoft,
                    backgroundImage: NetworkImage(profileImageUrl),
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundColor: _chatGreenSoft,
                    child: Text(
                      initials,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _chatGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _chatGreen.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _chatGreen,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
  }
}
