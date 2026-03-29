import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://test-j639.onrender.com/api',
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<Response> getHomeData() async => await _dio.get('/home');

  Future<Response> getClientDetails(String id) async => await _dio.get('/clients/$id');

  Future<Response> getTasks() async => await _dio.get('/tasks');
  Future<Response> createTask(Map<String, dynamic> taskData) async {
    return await _dio.post('/tasks', data: taskData);
  }

  Future<Response> getTaskDetails(String id) async => await _dio.get('/tasks/$id');

  Future<Response> updateTaskStatus(String id, String status) async {
    return await _dio.patch('/tasks/$id/status', data: {'status': status});
  }
}
