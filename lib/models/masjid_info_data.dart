import 'package:flutter/material.dart';

/// A single facility offered by the masjid.
class MasjidFacility {
  final String name;
  final IconData icon;

  const MasjidFacility({
    required this.name,
    required this.icon,
  });
}

/// Masjid information loaded from Firestore.
class MasjidInfo {
  final String name;
  final String locationLabel;
  final String address;
  final String phone;
  final String email;

  // Masjid photo uploaded to Cloudinary.
  final String photoUrl;

  final String imamName;
  final String imamPhone;
  final String imamBio;

  final String aboutText;

  final List<MasjidFacility> facilities;

  const MasjidInfo({
    required this.name,
    required this.locationLabel,
    required this.address,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.imamName,
    required this.imamPhone,
    required this.imamBio,
    required this.aboutText,
    required this.facilities,
  });

  factory MasjidInfo.fromFirestore(
      Map<String, dynamic> data,
      ) {
    final facilitiesData = data['facilities'];

    final facilities = <MasjidFacility>[];

    if (facilitiesData is Map) {
      final facilityIcons = <String, IconData>{
        'Wudu Area': Icons.water_drop_outlined,
        'Parking': Icons.local_parking_outlined,
        "Women's Prayer Area": Icons.groups_outlined,
        'Wheelchair Access': Icons.accessible_outlined,
        'Islamic Library': Icons.local_library_outlined,
      };

      facilitiesData.forEach((key, value) {
        if (value == true) {
          final name = key.toString();

          facilities.add(
            MasjidFacility(
              name: name,
              icon: facilityIcons[name] ??
                  Icons.check_circle_outline,
            ),
          );
        }
      });
    }

    return MasjidInfo(
      name: data['name']?.toString() ?? 'Masjid',

      locationLabel: _createLocationLabel(
        data['address']?.toString() ?? '',
      ),

      address: data['address']?.toString() ?? '',

      phone: data['phone']?.toString() ?? '',

      email: data['email']?.toString() ?? '',

      // Cloudinary photo URL
      photoUrl: data['photoUrl']?.toString() ?? '',

      imamName: data['imamName']?.toString() ?? '',

      imamPhone:
      data['imamContact']?.toString() ?? '',

      imamBio:
      data['imamBio']?.toString() ?? '',

      aboutText:
      data['about']?.toString() ?? '',

      facilities: facilities,
    );
  }

  static String _createLocationLabel(
      String address,
      ) {
    if (address.trim().isEmpty) {
      return 'Location not available';
    }

    final parts = address.split(',');

    if (parts.length >= 2) {
      return '${parts[parts.length - 2].trim()}, '
          '${parts.last.trim()}';
    }

    return address;
  }
}