import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final Function(int) onMenuItemTap;
  const SideBar({super.key, required this.onMenuItemTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color.fromRGBO(18, 18, 18, 1),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.list, 'All Tasks', 0),
          _buildMenuItem(context, Icons.check_box, 'Completed Tasks', 1),
          _buildMenuItem(context, Icons.access_time, 'Pending Tasks', 2),
          _buildMenuItem(context, Icons.info, 'About', 3),
          const Spacer(),
          _buildMenuItem(context, Icons.file_open, 'Create', 4),
          _buildMenuItem(context, Icons.file_upload, 'Upload', 5),
          _buildMenuItem(context, Icons.folder, 'CSV Folder', 6),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        onMenuItemTap(index);
      },
    );
  }
}
