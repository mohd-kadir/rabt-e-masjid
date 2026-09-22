import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/sensor_service.dart';
import '../services/qibla_calculator.dart';
import '../models/qibla_data.dart';

class QiblaViewModel extends ChangeNotifier {
  SensorService? _sensorService;

  double _qiblaAngle = 0.0;
  double get qiblaAngle => _qiblaAngle;

  double _deviceHeading = 0.0;
  double get deviceHeading => _deviceHeading;

  String _locationName = 'Fetching location...';
  String get locationName => _locationName;

  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;

  bool _isCalibrating = true;
  bool get isCalibrating => _isCalibrating;

  String _distanceToMakkah = 'Calculating...';
  String get distanceToMakkah => _distanceToMakkah;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  StreamSubscription? _qiblaSubscription;
  StreamSubscription? _compassSubscription;
  StreamSubscription? _locationSubscription;
  StreamSubscription? _errorSubscription;

  bool _isInitialized = false;

  QiblaViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      _sensorService = SensorService();
      await _sensorService!.startListening();

      _qiblaSubscription = _sensorService!.qiblaStream.listen(
            (qibla) {
          _qiblaAngle = qibla;
          QiblaData.qiblaDirectionDegrees = qibla;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {},
      );

      _compassSubscription = _sensorService!.compassStream.listen(
            (heading) {
          // ✅ Only update if value actually changed
          if ((_deviceHeading - heading).abs() > 0.1) {
            _deviceHeading = heading;
            _isCalibrating = _sensorService?.isCalibrating ?? true;
            notifyListeners();
          }
        },
        onError: (e) {},
      );

      _locationSubscription = _sensorService!.locationStream.listen(
            (position) {
          _isLocationEnabled = true;
          QiblaData.isLocationEnabled = true;
          _locationName = '📍 ${position.latitude!.toStringAsFixed(4)}, ${position.longitude!.toStringAsFixed(4)}';
          QiblaData.locationName = _locationName;

          final distance = QiblaCalculator.calculateDistance(
            position.latitude!,
            position.longitude!,
            QiblaCalculator.makkahLat,
            QiblaCalculator.makkahLng,
          );
          _distanceToMakkah = distance < 1
              ? '${(distance * 1000).toStringAsFixed(0)} m'
              : '${distance.toStringAsFixed(1)} km';
          QiblaData.distanceToMakkah = _distanceToMakkah;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {},
      );

      _errorSubscription = _sensorService!.errorStream.listen(
            (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
        },
        onError: (e) {},
      );

      final isEnabled = await Geolocator.isLocationServiceEnabled();
      _isLocationEnabled = isEnabled;
      QiblaData.isLocationEnabled = isEnabled;
      if (!isEnabled) {
        _errorMessage = 'Please enable location services';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error initializing: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    if (_isLoading) return;

    _isLoading = true;
    _isInitialized = false;
    notifyListeners();

    _sensorService?.stopListening();
    _sensorService?.dispose();
    _sensorService = null;

    await _initialize();
  }

  @override
  void dispose() {
    _qiblaSubscription?.cancel();
    _compassSubscription?.cancel();
    _locationSubscription?.cancel();
    _errorSubscription?.cancel();
    _sensorService?.stopListening();
    _sensorService?.dispose();
    _isInitialized = false;
    super.dispose();
  }
}