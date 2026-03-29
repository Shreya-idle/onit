import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../repositories/task_repository.dart';
import '../models/task_model.dart';

enum TaskStatus { initial, loading, loaded, error, empty }

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  TaskStatus _status = TaskStatus.initial;
  TaskStatus _detailsStatus = TaskStatus.initial;
  List<TaskModel> _tasks = [];
  TaskModel? _currentTask;
  String? _errorMessage;

  TaskStatus get status => _status;
  TaskStatus get detailsStatus => _detailsStatus;
  List<TaskModel> get tasks => _tasks;
  TaskModel? get currentTask => _currentTask;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
    _status = TaskStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getAllTasks();

      if (_tasks.isEmpty) {
        _status = TaskStatus.empty;
      } else {
        _status = TaskStatus.loaded;
      }
    } catch (e) {
      _status = TaskStatus.error;
      _errorMessage = "Failed to load tasks. Please try again.";
    }
    notifyListeners();
  }

  Future<void> fetchTaskDetails(String id) async {
    _detailsStatus = TaskStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentTask = await _repository.getTaskById(id);
      _detailsStatus = TaskStatus.loaded;
    } catch (e) {
      _detailsStatus = TaskStatus.error;
      _errorMessage = "Failed to load task details. Please try again.";
    }
    notifyListeners();
  }

  Future<bool> postTask(Map<String, dynamic> taskData) async {
    _status = TaskStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final task = TaskModel(
        id: '',
        title: taskData['title'] ?? '',
        description: taskData['description'] ?? '',
        category: taskData['category'] ?? '',
        budget: (taskData['budget'] as num?)?.toDouble() ?? 0.0,
        status: taskData['status'] ?? 'open',
        deadline: taskData['deadline'] ?? '',
      );
      await _repository.createTask(task);
      await fetchTasks();
      return true;
    } on DioException catch (e) {
      _errorMessage = e.response?.data?['message'] ?? e.message ?? "Failed to create task.";
      _status = TaskStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Failed to create task. ${e.toString()}";
      _status = TaskStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateStatus(String id, String newStatus) async {
    try {
      await _repository.updateStatus(id, newStatus);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        final oldTask = _tasks[index];
        _tasks[index] = TaskModel(
          id: oldTask.id,
          title: oldTask.title,
          description: oldTask.description,
          category: oldTask.category,
          budget: oldTask.budget,
          status: newStatus,
          deadline: oldTask.deadline,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }
}
