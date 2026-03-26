import 'package:flutter/material.dart';
import '../local_storage.dart';

import '../screens/detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/personal_info_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/notifications_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  Future<void> _signOut(BuildContext context) async {
    await LocalStorage.clearUserProfile();
    await LocalStorage.clearUserActions();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configure"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Personal Info"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Reports"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
