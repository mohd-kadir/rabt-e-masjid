import 'package:flutter/material.dart';

/// A single facility offered by the masjid.
class MasjidFacility {
  final String name;
  final IconData icon;

  const MasjidFacility({required this.name, required this.icon});
}

/// Mock Masjid Information data.
class MasjidInfo {
  MasjidInfo._();

  static const String name = 'Masjid Al-Noor';
  static const String locationLabel = 'Sector G-9, Islamabad';
  static const String address = 'Street 12, Sector G-9/1, Islamabad, Pakistan';
  static const String phone = '+92 51 234 5678';
  static const String email = 'info@masjidnoor.org';

  static const String imamName = 'Sheikh Abdullah Rahman';
  static const String imamPhone = '+92 300 1234567';
  static const String imamBio =
      'Imam Abdullah has led the congregation at Masjid Al-Noor for over 12 years. He holds an ijazah in '
      'Quranic recitation and regularly teaches evening classes on Fiqh and Seerah.';

  static const String aboutText =
      'Masjid Al-Noor has served the local Muslim community since 1998, offering daily prayers, Friday '
      'khutbahs, and educational programs for all ages. Our doors are open to worshippers and visitors '
      'alike, and we welcome everyone seeking a place of peace and remembrance.';

  static const List<MasjidFacility> facilities = [
    MasjidFacility(name: 'Wudu Area', icon: Icons.water_drop_outlined),
    MasjidFacility(name: 'Parking', icon: Icons.local_parking_outlined),
    MasjidFacility(name: "Women's Prayer Area", icon: Icons.groups_outlined),
    MasjidFacility(name: 'Wheelchair Access', icon: Icons.accessible_outlined),
    MasjidFacility(name: 'Islamic Library', icon: Icons.local_library_outlined),
  ];
}
