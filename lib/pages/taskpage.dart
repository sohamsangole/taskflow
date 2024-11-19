import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<List<dynamic>> _taskList = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _toggleTaskStatus(int index) async {
    setState(() {
      if (_taskList[index][3] == 'Pending') {
        _taskList[index][3] = 'Done';
      } else {
        _taskList[index][3] = 'Pending';
      }
    });
    await _saveTasksToFile();
  }

  Future<void> _saveTasksToFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filePath = prefs.getString('filePath');

    if (filePath != null && filePath.isNotEmpty) {
      try {
        File file = File(filePath);

        List<List<dynamic>> csvData = [
          [
            'Task ID',
            'Title',
            'Description',
            'Status',
            'Due Date',
            'Completion Date',
            'Completed On Time'
          ],
          ..._taskList
        ];

        // Convert the updated task list back to CSV format
        String csvContent = const ListToCsvConverter().convert(csvData);

        // Write the updated CSV content back to the file
        await file.writeAsString(csvContent);
      } catch (e) {
        print('Error writing to file: $e');
      }
    }
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filePath = prefs.getString('filePath');

    if (filePath != null && filePath.isNotEmpty) {
      try {
        File file = File(filePath);
        String fileContent = await file.readAsString();
        List<List<dynamic>> tasks =
            const CsvToListConverter().convert(fileContent);

        tasks.removeAt(0); // Remove the header row if it exists

        setState(() {
          _taskList = tasks;
        });
      } catch (e) {
        print('Error reading or parsing file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: _taskList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _taskList.length,
              itemBuilder: (context, index) {
                var task = _taskList[index];
                String status = task[3];
                Color textColor;

                if (status == 'Pending') {
                  textColor = Colors.white;
                } else {
                  textColor = Colors.green[600]!;
                }

                return ListTile(
                  title: Text(
                    task[1],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                    ),
                  ),
                  subtitle: Text(
                    task[2],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    task[3],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    _toggleTaskStatus(index);
                  },
                );
              },
            ),
    );
  }
}
