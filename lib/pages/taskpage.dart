import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
        _taskList[index][5] = DateFormat('d/M/yyyy').format(DateTime.now());
        var completedDate = DateTime.now();
        var dueDate = DateFormat('d/M/yyyy').parse(_taskList[index][4]);
        dueDate =
            DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);
        if (completedDate.isBefore(dueDate) ||
            completedDate.isAtSameMomentAs(dueDate) ||
            dueDate == completedDate) {
          _taskList[index][6] = 'Yes';
        } else {
          _taskList[index][6] = 'No';
        }
        print("$dueDate , $completedDate");
      } else {
        _taskList[index][3] = 'Pending';
        _taskList[index][5] = '';
        _taskList[index][6] = '';
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

  void _addNewTask() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0x00121212),
          title: const Text(
            'Add New Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, // Increased font size for the title
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  cursorColor: Colors.green,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increased font size for the input
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  cursorColor: Colors.green,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increased font size for the input
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  cursorColor: Colors.green,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increased font size for the input
                  ),
                  onTap: () async {
                    // Disable the keyboard on tap
                    FocusScope.of(context).requestFocus(FocusNode());

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.green,
                            colorScheme:
                                ColorScheme.light(primary: Colors.green),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      dueDateController.text = formattedDate;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                overlayColor:
                    WidgetStateProperty.all(Colors.green.withOpacity(0.2)),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  int newTaskId = _taskList.isEmpty
                      ? 1
                      : int.parse(_taskList.last[0].toString()) + 1;

                  _taskList.add([
                    newTaskId.toString(),
                    titleController.text,
                    descriptionController.text,
                    'Pending',
                    dueDateController.text,
                    '',
                    ''
                  ]);
                });
                _saveTasksToFile();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                overlayColor:
                    WidgetStateProperty.all(Colors.green.withOpacity(0.2)),
              ),
              child: const Text(
                'Add Task',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkFileExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filePath = prefs.getString('filePath');

    if (filePath == null) {
      return false;
    } else {
      File file = File(filePath);
      bool exists = await file.exists();

      if (exists) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        title: const Text(
          'Task List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
            child: GestureDetector(
              onTap: () async {
                bool fileExists = await _checkFileExists();
                if (fileExists) {
                  _addNewTask();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'File does not exist! Please check your storage settings.'),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _taskList.isEmpty
          ? const Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.green,
                ),
                SizedBox(
                  width: 18,
                ),
                Text(
                  "No Tasks!",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 36,
                  ),
                )
              ],
            ))
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
                    task[1].toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                    ),
                  ),
                  subtitle: Text(
                    task[2].toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Due: " + task[4],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _toggleTaskStatus(index);
                  },
                );
              },
            ),
    );
  }

  void _deleteTask(int index) async {
    setState(() {
      _taskList.removeAt(index);
    });
    await _saveTasksToFile();
  }
}
