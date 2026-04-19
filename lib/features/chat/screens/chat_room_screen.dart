import 'package:ewastecare/features/chat/controllers/chat_controller.dart';
import 'package:ewastecare/features/chat/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.otherUserName,
  });

  final String conversationId;
  final String otherUserId;
  final String otherUserName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static const Color _chatGreen = Color(0xFF2E7D32);
  static const Color _chatGreenSoft = Color(0xFFE8F5E9);
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final controller = Get.find<ChatController>();
    final url = await controller.resolveUserProfilePicture(widget.otherUserId);
    if (!mounted) return;
    setState(() => _profileImageUrl = url);
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(dateTime));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    controller.markConversationAsRead(widget.conversationId);
    final initials = widget.otherUserName.isNotEmpty
        ? widget.otherUserName[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            _profileImageUrl.trim().isNotEmpty
                ? CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    backgroundImage: NetworkImage(_profileImageUrl),
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.otherUserName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'messages'.tr,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: _chatGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _chatGreen.withOpacity(0.08),
                    Theme.of(context).colorScheme.surfaceContainerLowest,
                  ],
                ),
              ),
              child: StreamBuilder<List<ChatMessageModel>>(
                stream: controller.messagesStream(widget.conversationId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: _chatGreen.withOpacity(0.14),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: _chatGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'start_conversation'.tr,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }

                  controller.markConversationAsRead(widget.conversationId);

                  return ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == controller.currentUserId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: isMe ? _chatGreen : _chatGreenSoft,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isMe ? 18 : 6),
                                bottomRight: Radius.circular(isMe ? 6 : 18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: isMe
                                  ? null
                                  : Border.all(
                                      color: _chatGreen.withOpacity(0.2),
                                    ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 9, 12, 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message.text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isMe
                                              ? Colors.white
                                              : const Color(0xFF1B5E20),
                                        ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatTime(
                                          context,
                                          message.createdAt.toDate(),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: isMe
                                                  ? Colors.white.withOpacity(
                                                      0.86,
                                                    )
                                                  : const Color(0xFF2E7D32),
                                            ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          message.seenByUser(widget.otherUserId)
                                              ? Icons.done_all
                                              : Icons.done,
                                          size: 14,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) =>
                            controller.sendMessage(widget.conversationId),
                        decoration: InputDecoration(
                          hintText: 'type_message'.tr,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.9),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.messageController,
                      builder: (_, value, __) {
                        final canSend = value.text.trim().isNotEmpty;
                        return IconButton(
                          onPressed: canSend
                              ? () => controller.sendMessage(
                                  widget.conversationId,
                                )
                              : null,
                          style: IconButton.styleFrom(
                            backgroundColor: canSend
                                ? _chatGreen
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            foregroundColor: canSend
                                ? Colors.white
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          icon: const Icon(Iconsax.send_1),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
