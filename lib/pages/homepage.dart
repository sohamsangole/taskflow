import 'package:flutter/material.dart';
import 'package:taskflow/components/sidebar.dart';
import 'package:taskflow/pages/aboutpage.dart';
import 'package:taskflow/pages/completed.dart';
import 'package:taskflow/pages/pendingpage.dart';
import 'package:taskflow/pages/taskpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
  }

  final List<Widget> _pages = [
    const TaskPage(),
    const CompletedPage(),
    const PendingPage(),
    const AboutPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            onMenuItemTap: (index) {
              if (index == 4) {
                _createCSV();
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _filePath == null
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.7),
                child: const Text(
                  'No CSV File Saved Yet.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _checkIfFileExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedFilePath = prefs.getString('filePath');

    setState(() {
      _filePath = savedFilePath;
    });
  }

  Future<void> _createCSV() async {
    List<List<String>> rows = [
      [
        'Task ID',
        'Title',
        'Description',
        'Status',
        'Due Date',
        'Completion Date',
        'Completed On Time'
      ],
      [
        '1',
        'Task 1',
        'Complete the documentation',
        'Pending',
        '2024-11-21',
        '',
        'No'
      ],
    ];

    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      String path = '$directoryPath/tasks.csv';
      final file = File(path);
      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);
      print('CSV file created at: $path');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('filePath', path);
      print('File path saved in SharedPreferences: $path');
    } else {
      print('No directory selected.');
    }
  }
}
