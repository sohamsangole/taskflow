import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color.fromRGBO(18, 18, 18, 1),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.list, 'All Tasks', () {}),
          _buildMenuItem(context, Icons.check_box, 'Completed Tasks', () {}),
          _buildMenuItem(context, Icons.access_time, 'Pending Tasks', () {}),
          _buildMenuItem(context, Icons.settings, 'Settings', () {}),
          _buildMenuItem(context, Icons.info, 'About', () {}),
          const Spacer(),
          _buildMenuItem(context, Icons.file_open, 'Create', () {}),
          _buildMenuItem(context, Icons.file_upload, 'Upload', () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
