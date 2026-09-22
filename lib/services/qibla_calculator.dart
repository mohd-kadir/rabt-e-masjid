import 'dart:math';

class QiblaCalculator {
  // Makkah coordinates
  static const double makkahLat = 21.4225;
  static const double makkahLng = 39.8262;

  /// Calculate Qibla direction from current location
  static double calculateQibla(double lat, double lng) {
    // Convert degrees to radians
    final lat1 = _degToRad(lat);
    final lat2 = _degToRad(makkahLat);
    final deltaLng = _degToRad(makkahLng - lng);

    // Spherical trigonometry formula
    final x = sin(deltaLng) * cos(lat2);
    final y = (cos(lat1) * sin(lat2)) - (sin(lat1) * cos(lat2) * cos(deltaLng));

    // Calculate bearing
    var bearing = atan2(x, y);
    bearing = _radToDeg(bearing);
    bearing = (bearing + 360) % 360; // Normalize to 0-360

    return bearing;
  }

  static double _degToRad(double deg) => deg * pi / 180.0;
  static double _radToDeg(double rad) => rad * 180.0 / pi;

  /// Calculate distance between two coordinates in km
  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371; // Earth's radius in km
    final dLat = _degToRad(lat2 - lat1);
    final dLng = _degToRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }
}