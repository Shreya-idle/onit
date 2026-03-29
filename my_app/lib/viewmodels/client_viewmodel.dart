import 'package:flutter/material.dart';
import '../repositories/client_repository.dart';
import '../models/client_details.dart';

enum ClientStatus { initial, loading, loaded, error, empty }

class ClientViewModel extends ChangeNotifier {
  final ClientRepository _repository = ClientRepository();

  ClientStatus _status = ClientStatus.initial;
  ClientDetails? _clientData;
  String? _errorMessage;

  ClientStatus get status => _status;
  ClientDetails? get clientData => _clientData;
  String? get errorMessage => _errorMessage;

  Future<void> fetchClientDetails(String id) async {
    _status = ClientStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _clientData = await _repository.fetchClientDetails(id);
      
      if (_clientData == null) {
        _status = ClientStatus.empty;
      } else {
        _status = ClientStatus.loaded;
      }
    } catch (e) {
      _status = ClientStatus.error;
      _errorMessage = "Failed to load client details. Please try again.";
      debugPrint("ClientViewModel error: $e");
    }
    notifyListeners();
  }
}
