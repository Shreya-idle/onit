import '../services/api_service.dart';
import '../models/client_details.dart';

class ClientRepository {
  final ApiService _apiService = ApiService();

  Future<ClientDetails> fetchClientDetails(String id) async {
    try {
      final response = await _apiService.getClientDetails(id);
      return ClientDetails.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch client details from repository: $e");
    }
  }
}
