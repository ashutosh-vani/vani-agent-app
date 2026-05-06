import 'package:flutter/material.dart';
import 'package:vani_app/config/theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;
  final bool showNotification;

  const AppHeader({
    super.key,
    this.onMenuPressed,
    this.onProfilePressed,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: const Text(
        'VaniAgent',
        style: TextStyle(
          color: AppTheme.darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (showNotification)
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.darkGrey),
            onPressed: () {},
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onProfilePressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightGrey,
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.darkGrey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
