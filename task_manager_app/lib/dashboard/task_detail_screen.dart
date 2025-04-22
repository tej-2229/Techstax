import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Task>> _tasksFuture;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _isCompleted = widget.task.isCompleted;
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = _supabaseService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 40, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 40, 50, 1),
        elevation: 0,
        title: const Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(140, 170, 185, 1),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(69, 90, 100, 1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(140, 170, 185, 1),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(69, 90, 100, 1),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(69, 90, 100, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Status',
                  style: TextStyle(
                    color:
                        _isCompleted ? Colors.green[200] : Colors.orange[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _isCompleted ? 'Completed' : 'In Progress',
                  style: const TextStyle(color: Colors.grey),
                ),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
                activeColor: Colors.green[400],
                inactiveThumbColor: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title cannot be empty')),
                      );
                      return;
                    }

                    final updatedTask = widget.task.copyWith(
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      isCompleted: _isCompleted,
                      updatedAt: DateTime.now(),
                    );

                    setState(() => _isSaving = true);

                    await _supabaseService.updateTask(updatedTask);
                    if (mounted) {
                      _refreshTasks();
                      Navigator.pop(context, updatedTask);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isSaving = false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(254, 211, 106, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child:
                    _isSaving
                        ? const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        )
                        : const Text(
                          'SAVE CHANGES',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
