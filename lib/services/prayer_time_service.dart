import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class PrayerTimeService {
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';

  static Future<Map<String, String>> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    int method = 1,
  }) async {
    final url = '$_baseUrl/${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
        '?latitude=$latitude&longitude=$longitude&method=$method&school=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        return {
          'Fajr': timings['Fajr'] ?? '--:--',
          'Sunrise': timings['Sunrise'] ?? '--:--',
          'Dhuhr': timings['Dhuhr'] ?? '--:--',
          'Asr': timings['Asr'] ?? '--:--',
          'Maghrib': timings['Maghrib'] ?? '--:--',
          'Isha': timings['Isha'] ?? '--:--',
        };
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error fetching prayer times: $e');
    }
  }

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}