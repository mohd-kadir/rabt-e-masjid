import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/prayer_time_service.dart';
import '../services/hijri_calendar_service.dart';
import '../models/hijri_calendar_data.dart';

class AppDataProvider extends ChangeNotifier {
  Position? _currentPosition;
  Map<String, String>? _prayerTimes;
  DateTime? _currentDate;
  HijriDate? _hijriDate;
  String? _errorMessage;
  bool _isLoading = false;
  Timer? _timer;
  int _hijriAdjustment = 0; // ✅ ADDED

  Position? get currentPosition => _currentPosition;
  Map<String, String>? get prayerTimes => _prayerTimes;
  DateTime get currentDate => _currentDate ?? DateTime.now();
  HijriDate? get hijriDate => _hijriDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get hijriAdjustment => _hijriAdjustment; // ✅ ADDED

  AppDataProvider() {
    _currentDate = DateTime.now();
    _loadHijriAdjustment(); // ✅ ADDED
    _initializeData();
    _startTimer();
  }

  // ✅ ADDED: Load saved adjustment
  Future<void> _loadHijriAdjustment() async {
    final prefs = await SharedPreferences.getInstance();
    _hijriAdjustment = prefs.getInt('hijri_adjustment') ?? 0;
    _updateHijriDate();
  }

  // ✅ ADDED: Set & save adjustment
  Future<void> setHijriAdjustment(int value) async {
    _hijriAdjustment = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hijri_adjustment', value);
    _updateHijriDate();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      refreshData();
    });
  }

  Future<void> _initializeData() async {
    await fetchLocationAndPrayerTimes();
    _updateHijriDate();
  }

  Future<void> fetchLocationAndPrayerTimes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPosition = await PrayerTimeService.getCurrentLocation();
      _prayerTimes = await PrayerTimeService.getPrayerTimes(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        date: _currentDate!,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _useFallbackData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateHijriDate() {
    // ✅ Adjustment pass karein
    _hijriDate = HijriCalendarService.convertGregorianToHijri(
      _currentDate!,
      adjustment: _hijriAdjustment,
    );
    notifyListeners();
  }

  Future<void> refreshData() async {
    _currentDate = DateTime.now();
    await fetchLocationAndPrayerTimes();
    _updateHijriDate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _useFallbackData() {
    _prayerTimes = {
      'Fajr': '04:34 AM',
      'Sunrise': '06:01 AM', // ✅ ADDED
      'Dhuhr': '12:20 PM',
      'Asr': '04:52 PM',
      'Maghrib': '06:37 PM',
      'Isha': '07:58 PM',
    };
  }
}