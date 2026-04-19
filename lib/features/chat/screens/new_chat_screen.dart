import 'dart:async';

import 'package:ewastecare/features/chat/controllers/chat_controller.dart';
import 'package:ewastecare/features/chat/models/chat_user_model.dart';
import 'package:ewastecare/features/chat/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _query = '';

  static const Color _chatGreen = Color(0xFF2E7D32);

  Future<void> _openChat(ChatController controller, ChatUserModel user) async {
    final conversationId = await controller.startConversation(user.id);
    if (!mounted) return;
    Get.off(
      () => ChatRoomScreen(
        conversationId: conversationId,
        otherUserId: user.id,
        otherUserName: user.name,
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(title: Text('new_chat'.tr), centerTitle: false),
      body: StreamBuilder<List<ChatUserModel>>(
        stream: controller.usersStream(),
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

          final users = snapshot.data ?? <ChatUserModel>[];
          if (users.isEmpty) {
            return Center(child: Text('no_users_found'.tr));
          }

          final filteredUsers =
              users.where((user) {
                if (_query.trim().isEmpty) return true;
                final keyword = _query.trim().toLowerCase();
                final matchesName = user.name.toLowerCase().contains(keyword);
                final roleKeyword = user.isAdmin ? 'admin' : 'user';
                final matchesRole =
                    keyword.length >= 3 && roleKeyword.contains(keyword);
                return matchesName || matchesRole;
              }).toList()..sort(
                (a, b) => a.name.trim().toLowerCase().compareTo(
                  b.name.trim().toLowerCase(),
                ),
              );

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _chatGreen.withOpacity(0.09),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _searchDebounce?.cancel();
                      _searchDebounce = Timer(
                        const Duration(milliseconds: 300),
                        () {
                          if (!mounted) return;
                          setState(() => _query = value);
                        },
                      );
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.search_normal),
                      prefixIconColor: _chatGreen,
                      hintText: 'search_users'.tr,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? Center(child: Text('no_matching_users'.tr))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            final displayName = user.name.trim();
                            final currentHeader = displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : '#';
                            final previousHeader = index > 0
                                ? (filteredUsers[index - 1].name
                                          .trim()
                                          .isNotEmpty
                                      ? filteredUsers[index - 1].name
                                            .trim()[0]
                                            .toUpperCase()
                                      : '#')
                                : '';
                            final showHeader =
                                index == 0 || currentHeader != previousHeader;
                            final roleLabel = user.isAdmin
                                ? 'adminRole'.tr
                                : 'userRole'.tr;
                            final initials = displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : '?';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showHeader)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        2,
                                        6,
                                        2,
                                        8,
                                      ),
                                      child: Text(
                                        currentHeader,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: _chatGreen,
                                            ),
                                      ),
                                    ),
                                  Material(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => _openChat(controller, user),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: _chatGreen
                                                  .withOpacity(0.14),
                                              backgroundImage:
                                                  user.profilePicture
                                                      .trim()
                                                      .isNotEmpty
                                                  ? NetworkImage(
                                                      user.profilePicture,
                                                    )
                                                  : null,
                                              child:
                                                  user.profilePicture
                                                      .trim()
                                                      .isNotEmpty
                                                  ? null
                                                  : Text(
                                                      initials,
                                                      style: const TextStyle(
                                                        color: _chatGreen,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: _chatGreen
                                                          .withOpacity(0.11),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            99,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      roleLabel,
                                                      style: const TextStyle(
                                                        color: _chatGreen,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            FilledButton.icon(
                                              onPressed: () =>
                                                  _openChat(controller, user),
                                              style: FilledButton.styleFrom(
                                                backgroundColor: _chatGreen,
                                                foregroundColor: Colors.white,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                              ),
                                              icon: const Icon(
                                                Iconsax.message_text_1,
                                                size: 16,
                                              ),
                                              label: Text('new_chat'.tr),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
