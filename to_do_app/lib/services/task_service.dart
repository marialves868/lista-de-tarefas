import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  final String _boxName = 'tasksBox';

  Future<void> addTask(Task task) async {
    final box = await Hive.openBox<Task>(_boxName);
    await box.add(task);
  }

  Future<List<Task>> getTasks() async {
    final box = await Hive.openBox<Task>(_boxName);
    return box.values.toList();
  }

  Future<void> updateTask(Task task) async {
    task.save();
  }

  Future<void> deleteTask(Task task) async {
    task.delete();
  }
}
