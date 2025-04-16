import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<NotificationItem> notifications = const [
    NotificationItem(
      message: 'You’re low on washing up liquid!',
      icon: Icons.warning_amber_rounded,
      backgroundColor: Color(0xFFFFF2CC),
      iconColor: Color(0xFFF8D788),
    ),
    NotificationItem(
      message: 'Check kitchen stock!',
      icon: Icons.location_on_rounded,
      backgroundColor: Color(0xFFE6D6F1),
      iconColor: Color(0xFFAEACDD),
    ),
    NotificationItem(
      message: 'Bathroom cleaner very low.',
      icon: Icons.error_outline,
      backgroundColor: Color(0xFFFFD6DE),
      iconColor: Color(0xFFEA9E92),
    ),
    NotificationItem(
      message: 'Reminder: Inventory updated',
      icon: Icons.mail_outline,
      backgroundColor: Color(0xFFDFF1F1),
      iconColor: Color(0xFF93C5C5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppTopBar(showBack: true, context: context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF515254),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length * 2,
                itemBuilder: (context, index) {
                  final item = notifications[index % notifications.length];
                  return Dismissible(
                    key: Key('$index-${item.message}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {},
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.black,
                      ),
                    ),
                    child: NotificationCard(notification: item),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const NotificationItem({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 340,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: notification.backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(notification.icon, size: 28, color: notification.iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.message,
                style: const TextStyle(
                  color: Color(0xFF515254),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
