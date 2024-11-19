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
          _buildMenuItem(context, Icons.list, 'All Tasks', () {
            Navigator.pushNamed(context, '/all-tasks');
          }),
          _buildMenuItem(context, Icons.check_box, 'Completed Tasks', () {
            Navigator.pushNamed(context, '/completed-tasks');
          }),
          _buildMenuItem(context, Icons.access_time, 'Pending Tasks', () {
            Navigator.pushNamed(context, '/pending-tasks');
          }),
          _buildMenuItem(context, Icons.settings, 'Settings', () {
            Navigator.pushNamed(context, '/settings');
          }),
          _buildMenuItem(context, Icons.info, 'About', () {
            Navigator.pushNamed(context, '/about');
          }),
          Spacer(),
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
