import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';
import '../../../data/models/models.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String salonId;
  final String salonName;
  final String salonImage;

  const ChatScreen({
    super.key,
    required this.salonId,
    required this.salonName,
    required this.salonImage,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesProvider(widget.salonId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.salonImage.isNotEmpty
                  ? CachedNetworkImageProvider(widget.salonImage)
                  : null,
              child: widget.salonImage.isEmpty
                  ? const Icon(Icons.store, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.salonName, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15)),
                Text('Online', style: AppTextStyles.small.copyWith(color: AppColors.success)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone, color: AppColors.primary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textDark), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: chatMessages.when(
              data: (messages) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length + 1,
                itemBuilder: (_, i) {
                  if (i == messages.length) {
                    return _TypingIndicator(image: widget.salonImage);
                  }
                  return _ChatBubble(message: messages[i], salonImage: widget.salonImage);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.attach_file, color: AppColors.textGrey), onPressed: () {}),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTextStyles.body.copyWith(fontSize: 14),
                            ),
                          ),
                          const Icon(Icons.emoji_emotions_outlined, color: AppColors.textGrey, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: AppColors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final String salonImage;

  const _ChatBubble({required this.message, required this.salonImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(salonImage),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: message.imageUrl!,
                      width: 180,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (message.text != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: message.isMe ? AppColors.chatBubbleMe : AppColors.chatBubbleOther,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                        bottomRight: Radius.circular(message.isMe ? 4 : 20),
                      ),
                    ),
                    child: Text(
                      message.text!,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: message.isMe ? AppColors.textDark : AppColors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message.time, style: AppTextStyles.small.copyWith(fontSize: 11)),
                    if (message.isMe && message.isRead) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.done_all, size: 14, color: AppColors.accent),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final String image;
  const _TypingIndicator({required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(image)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.chatBubbleOther,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => Container(
              width: 8, height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            )),
          ),
        ),
      ],
    );
  }
}
