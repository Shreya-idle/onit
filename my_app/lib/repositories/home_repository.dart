import '../services/api_service.dart';
import '../models/home_data.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  Future<HomeData> fetchHome() async {
    try {
      final response = await _apiService.getHomeData();
      return HomeData.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch home data from repository: $e");
    }
  }
}
