import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
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
      var task = _completedTasks[index];
      task[3] = 'Pending';
      task[5] = '';
      task[6] = '';
      _completedTasks.removeAt(index);
      _taskList.add(task);
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
          'Completed Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: _completedTasks.isEmpty
          ? const Center(
              child: Text(
                'No completed tasks yet!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _completedTasks.length,
              itemBuilder: (context, index) {
                var task = _completedTasks[index];

                return ListTile(
                  title: Text(
                    task[1].toString(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Completed on : " + task[5].toString(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.undo, color: Colors.green),
                  onTap: () {
                    _toggleTaskState(index);
                  },
                );
              },
            ),
    );
  }
}
