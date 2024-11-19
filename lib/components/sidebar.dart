import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color.fromRGBO(18, 18, 18, 1),
      child: Column(
        children: [
          Text("All Tasks"),
          Text("Completed Tasks"),
          Text("Pending Tasks"),
          Text("Settings"),
          Text("About"),
        ],
      ),
    );
  }
}
