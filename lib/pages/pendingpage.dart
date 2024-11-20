import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  List<List<dynamic>> _taskList = [];
  List<List<dynamic>> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
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

        tasks.removeAt(0);

        setState(() {
          _completedTasks = tasks.where((task) => task[3] == 'Done').toList();
          _taskList = tasks.where((task) => task[3] != 'Done').toList();
        });
      } catch (e) {
        print('Error reading or parsing file: $e');
      }
    }
  }

  void _toggleTaskState(int index) {
    setState(() {
      var task = _taskList[index];
      task[3] = 'Done';

      var completedDate = DateTime.now();
      task[5] = DateFormat('d/M/yyyy').format(DateTime.now());

      var dueDate = DateFormat('d/M/yyyy').parse(task[4]);
      dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);
      if (completedDate.isBefore(dueDate) ||
          completedDate.isAtSameMomentAs(dueDate) ||
          dueDate == completedDate) {
        task[6] = 'Yes';
      } else {
        task[6] = 'No';
      }
      _taskList.removeAt(index);
      _completedTasks.add(task);
    });

    _saveTasks();
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filePath = prefs.getString('filePath');

    if (filePath != null && filePath.isNotEmpty) {
      try {
        File file = File(filePath);

        List<List<dynamic>> allTasks = [..._taskList, ..._completedTasks];
        allTasks.insert(0, [
          'Task ID',
          'Title',
          'Description',
          'Status',
          'Due Date',
          'Completion Date',
          'Completed On Time'
        ]);

        String csv = const ListToCsvConverter().convert(allTasks);
        await file.writeAsString(csv);
      } catch (e) {
        print('Error saving file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: _taskList.isEmpty
          ? const Center(
              child: Text(
                'No pending tasks yet!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _taskList.length,
              itemBuilder: (context, index) {
                var task = _taskList[index];

                return ListTile(
                  title: Text(
                    task[1].toString(),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 28,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Due: " + task[4],
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.check, color: Colors.orange),
                  onTap: () {
                    _toggleTaskState(index);
                  },
                );
              },
            ),
    );
  }
}
