import 'package:flutter/material.dart';
import '../repositories/home_repository.dart';
import '../models/home_data.dart';

enum HomeStatus { initial, loading, loaded, error, empty }

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  HomeStatus _status = HomeStatus.initial;
  HomeData? _homeData;
  String? _errorMessage;

  HomeStatus get status => _status;
  HomeData? get homeData => _homeData;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeData() async {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _homeData = await _repository.fetchHome();
      
      if (_homeData == null) {
        _status = HomeStatus.empty;
      } else {
        _status = HomeStatus.loaded;
      }
    } catch (e) {
      _status = HomeStatus.error;
      _errorMessage = "Failed to load home data. Please try again.";
    }
    notifyListeners();
  }
  
}
