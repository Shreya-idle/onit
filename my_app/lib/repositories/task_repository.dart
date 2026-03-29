import '../services/api_service.dart';
import '../models/task_model.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  Future<List<TaskModel>> getAllTasks() async {
    final response = await _apiService.getTasks();
    return (response.data as List).map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<TaskModel> getTaskById(String id) async {
    final response = await _apiService.getTaskDetails(id);
    return TaskModel.fromJson(response.data);
  }

  Future<void> createTask(TaskModel task) async {
    await _apiService.createTask(task.toJson());
  }

  Future<void> updateStatus(String id, String status) async {
    await _apiService.updateTaskStatus(id, status);
  }
}
