import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;
  final BuildContext context;

  const AppTopBar({
    super.key,
    required this.showBack,
    this.onBack,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left icon: Back or Profile
            IconButton(
              icon: Icon(
                showBack ? Icons.arrow_back : Icons.person,
                size: 56,
                color: Colors.black, //
              ),
              onPressed:
                  showBack
                      ? (onBack ?? () => Navigator.pop(context))
                      : () {
                        Navigator.pushNamed(context, '/settings');
                      },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            // Right icon: Logo popup
            PopupMenuButton<String>(
              icon: Image.asset('assets/domi_logo_textless.png', height: 56),
              onSelected: (value) {
                Navigator.pushNamed(context, value);
              },
              itemBuilder:
                  (BuildContext context) => const [
                    PopupMenuItem(
                      value: '/dashboard',
                      child: Text('Dashboard'),
                    ),
                    PopupMenuItem(
                      value: '/inventory',
                      child: Text('Inventory'),
                    ),
                    PopupMenuItem(value: '/scan', child: Text('Add Item')),
                    PopupMenuItem(
                      value: '/notifications',
                      child: Text('Notifications'),
                    ),
                    PopupMenuItem(value: '/settings', child: Text('Settings')),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
