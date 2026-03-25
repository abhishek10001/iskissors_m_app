import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';
import '../../../data/models/models.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textGrey,
              labelStyle: AppTextStyles.bodySemiBold,
              unselectedLabelStyle: AppTextStyles.body,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Message'),
                Tab(text: 'Notification'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MessageList(),
                  _NotificationList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);

    return messages.when(
      data: (msgs) => Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Text('Search messages or salon', style: AppTextStyles.caption.copyWith(color: AppColors.textLight)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: msgs.length,
              separatorBuilder: (_, __) => const Divider(indent: 86, endIndent: 20, height: 1),
              itemBuilder: (_, i) {
                final msg = msgs[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: CachedNetworkImageProvider(msg.salonImage),
                  ),
                  title: Text(msg.salonName, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15)),
                  subtitle: Text(msg.lastMessage, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(msg.time, style: AppTextStyles.small),
                      if (msg.unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 22, height: 22,
                          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                          child: Center(child: Text('${msg.unreadCount}', style: AppTextStyles.small.copyWith(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w600))),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => context.push('/chat/${msg.id}?name=${Uri.encodeComponent(msg.salonName)}&image=${Uri.encodeComponent(msg.salonImage)}'),
                );
              },
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return notifications.when(
      data: (notifs) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifs.length,
        itemBuilder: (_, i) {
          final n = notifs[i];
          IconData icon;
          Color iconBg;
          switch (n.type) {
            case NotificationType.reminder:
              icon = Icons.alarm;
              iconBg = AppColors.accent;
              break;
            case NotificationType.payment:
              icon = Icons.payment;
              iconBg = AppColors.success;
              break;
            case NotificationType.offer:
              icon = Icons.local_offer;
              iconBg = AppColors.primary;
              break;
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: n.isNew ? AppColors.primaryLight : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: n.isNew ? AppColors.primary.withValues(alpha: 0.2) : AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                      if (n.body.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(n.body, style: AppTextStyles.caption),
                      ],
                    ],
                  ),
                ),
                Text(n.time, style: AppTextStyles.small),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
