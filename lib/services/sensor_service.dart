import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'qibla_calculator.dart';

class SensorService {
  // Stream controllers
  final _qiblaStreamController = StreamController<double>.broadcast();
  final _compassStreamController = StreamController<double>.broadcast();
  final _locationStreamController = StreamController<Position>.broadcast();
  final _errorStreamController = StreamController<String>.broadcast();

  // Get streams
  Stream<double> get qiblaStream => _qiblaStreamController.stream;
  Stream<double> get compassStream => _compassStreamController.stream;
  Stream<Position> get locationStream => _locationStreamController.stream;
  Stream<String> get errorStream => _errorStreamController.stream;

  // Current values
  Position? _currentPosition;
  double _currentHeading = 0.0;
  double _currentQibla = 0.0;
  bool _isListening = false;
  bool _isLocationEnabled = false;
  bool _isCalibrating = true;

  // Subscriptions
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<MagnetometerEvent>? _compassSubscription;

  // Getters
  bool get isLocationEnabled => _isLocationEnabled;
  bool get isCalibrating => _isCalibrating;
  Position? get currentPosition => _currentPosition;
  double get currentQibla => _currentQibla;
  double get currentHeading => _currentHeading;

  Future<void> startListening() async {
    if (_isListening) return;
    _isListening = true;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied) {
        _safeAddError('Location permission denied');
        return;
      }
    }

    _isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_isLocationEnabled) {
      _safeAddError('Location services are disabled');
    }

    _listenToLocation();
    _listenToCompass();
  }

  void _listenToLocation() {
    _locationSubscription?.cancel();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
          (Position position) {
        if (!_isListening) return;

        _currentPosition = position;
        _isLocationEnabled = true;

        if (position.latitude != null && position.longitude != null) {
          _currentQibla = QiblaCalculator.calculateQibla(
            position.latitude!,
            position.longitude!,
          );

          _safeAddQibla(_currentQibla);
          _safeAddLocation(position);
        }
      },
      onError: (error) {
        _safeAddError('Location error: $error');
        _isLocationEnabled = false;
      },
    );
  }

  void _listenToCompass() {
    _compassSubscription?.cancel();

    _compassSubscription = magnetometerEvents.listen(
          (MagnetometerEvent event) {
        if (!_isListening) return;

        final heading = _calculateHeading(event.x, event.y);
        _currentHeading = heading;

        // Check calibration
        _checkCalibration(event);

        _safeAddCompass(heading);
      },
      onError: (error) {
        _safeAddError('Compass error: $error');
      },
    );
  }

  // ✅ Calibration check
  void _checkCalibration(MagnetometerEvent event) {
    final magnitude = sqrt(
        event.x * event.x +
            event.y * event.y +
            event.z * event.z
    );

    // Earth's magnetic field: 25-65 µT
    if (magnitude < 20 || magnitude > 70) {
      _isCalibrating = true;
    } else {
      _isCalibrating = false;
    }
  }

  double _calculateHeading(double x, double y) {
    var heading = atan2(y, x) * 180 / pi;
    heading = (heading + 360) % 360;
    return heading;
  }

  double getQiblaRelativeToDevice() {
    double relative = _currentQibla - _currentHeading;
    return (relative + 360) % 360;
  }

  // Safe add methods
  void _safeAddQibla(double value) {
    try {
      if (!_qiblaStreamController.isClosed) {
        _qiblaStreamController.add(value);
      }
    } catch (e) {}
  }

  void _safeAddCompass(double value) {
    try {
      if (!_compassStreamController.isClosed) {
        _compassStreamController.add(value);
      }
    } catch (e) {}
  }

  void _safeAddLocation(Position value) {
    try {
      if (!_locationStreamController.isClosed) {
        _locationStreamController.add(value);
      }
    } catch (e) {}
  }

  void _safeAddError(String value) {
    try {
      if (!_errorStreamController.isClosed) {
        _errorStreamController.add(value);
      }
    } catch (e) {}
  }

  void stopListening() {
    _isListening = false;
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _locationSubscription = null;
    _compassSubscription = null;
  }

  void dispose() {
    stopListening();
    try {
      if (!_qiblaStreamController.isClosed) {
        _qiblaStreamController.close();
      }
    } catch (e) {}
    try {
      if (!_compassStreamController.isClosed) {
        _compassStreamController.close();
      }
    } catch (e) {}
    try {
      if (!_locationStreamController.isClosed) {
        _locationStreamController.close();
      }
    } catch (e) {}
    try {
      if (!_errorStreamController.isClosed) {
        _errorStreamController.close();
      }
    } catch (e) {}
  }
}