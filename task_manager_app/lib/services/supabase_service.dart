import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Task>> getTasks() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((task) => Task.fromJson(task)).toList();
  }

  Future<void> addTask(String title, String description) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('tasks').insert({
      'title': title,
      'description': description,
      'user_id': userId,
      'is_completed': false,
    });
  }

  Future<void> updateTask(Task task) async {
    await _supabase
        .from('tasks')
        .update({
          'title': task.title,
          'description': task.description,
          'is_completed': task.isCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', task.id);
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final profileResponse =
          await _supabase
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();

      if (profileResponse != null) {
        return profileResponse;
      }
      final authResponse = await _supabase.auth.getUser();
      return {
        'full_name': authResponse.user?.userMetadata?['full_name'] ?? 'User',
        'email': authResponse.user?.email ?? '',
      };
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return {};
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _supabase.from('tasks').delete().eq('id', taskId);
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _supabase
        .from('tasks')
        .update({'is_completed': !isCompleted})
        .eq('id', taskId);
  }
}
