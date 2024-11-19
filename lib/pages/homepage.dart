import 'package:flutter/material.dart';
import 'package:taskflow/components/sidebar.dart';
import 'package:taskflow/pages/taskpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const TaskPage(),
    const TaskPage(),
    const TaskPage(),
    const Center(
        child: Text("Settings Content", style: TextStyle(fontSize: 24))),
    const Center(child: Text("About Content", style: TextStyle(fontSize: 24))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            onMenuItemTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
