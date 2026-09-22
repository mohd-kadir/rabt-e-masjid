/// Qibla data model - will be populated by ViewModel with real-time data
class QiblaData {
  QiblaData._();

  // These will be updated by QiblaViewModel
  static String locationName = 'Fetching location...';
  static bool isLocationEnabled = false;
  static double qiblaDirectionDegrees = 0.0;
  static String distanceToMakkah = 'Calculating...';
}