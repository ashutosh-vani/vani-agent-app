import 'package:flutter/material.dart';
import 'package:vani_app/screens/dashboard/dashboard_screen.dart';
import 'package:vani_app/screens/agents/agents_screen.dart';
import 'package:vani_app/screens/campaigns/campaigns_screen.dart';
import 'package:vani_app/screens/contacts/contacts_screen.dart';
import 'package:vani_app/screens/call_history/call_history_screen.dart';
import 'package:vani_app/widgets/app_bottom_navigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardScreen(),
          AgentsScreen(),
          CampaignsScreen(),
          ContactsScreen(),
          CallHistoryScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
