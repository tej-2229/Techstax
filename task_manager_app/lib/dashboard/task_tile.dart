import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        color: Color.fromRGBO(69, 90, 100, 1),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggle(),
            shape: const CircleBorder(),
            side: const BorderSide(color: Colors.white),
  checkColor: Colors.black, 
  activeColor: Colors.white, 
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: Colors.white,
              decoration:
                  task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white,),
                ),
              Text(
                DateFormat('MMM dd, yyyy - hh:mm a').format(task.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white,),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}