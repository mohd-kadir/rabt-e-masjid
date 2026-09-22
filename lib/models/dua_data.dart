import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A single Dua/Azkar category shown as a card on the Dua & Azkar screen.
class DuaCategory {
  final String name;
  final String description;
  final IconData icon;
  final int duaCount;

  const DuaCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.duaCount,
  });
}

/// The eight Dua & Azkar categories.
const List<DuaCategory> duaCategories = [
  DuaCategory(
    name: 'Morning Azkar',
    description: 'Start your day with remembrance',
    icon: Icons.wb_sunny_outlined,
    duaCount: 18,
  ),
  DuaCategory(
    name: 'Evening Azkar',
    description: 'Close your day in gratitude',
    icon: Icons.wb_twilight_outlined,
    duaCount: 16,
  ),
  DuaCategory(
    name: 'After Salah',
    description: 'Supplications after each prayer',
    icon: Icons.mosque_outlined,
    duaCount: 12,
  ),
  DuaCategory(
    name: 'Before Sleeping',
    description: 'Peaceful duas before rest',
    icon: Icons.bedtime_outlined,
    duaCount: 9,
  ),
  DuaCategory(
    name: 'Travel',
    description: 'For a safe and blessed journey',
    icon: Icons.flight_takeoff_rounded,
    duaCount: 7,
  ),
  DuaCategory(
    name: 'Protection',
    description: 'Seeking refuge and safety',
    icon: Icons.shield_outlined,
    duaCount: 11,
  ),
  DuaCategory(
    name: 'Forgiveness',
    description: 'Seeking Allah\'s mercy',
    icon: Icons.volunteer_activism_outlined,
    duaCount: 8,
  ),
  DuaCategory(
    name: 'Daily Duas',
    description: 'Everyday moments and needs',
    icon: Icons.auto_stories_outlined,
    duaCount: 22,
  ),
];

/// Full content for a single Dua/Zikr, shown on the Dua Detail screen.
class DuaEntry {
  final String id;
  final String categoryName;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;

  const DuaEntry({
    required this.id,
    required this.categoryName,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
  });
}

/// Mock full-content duas, grouped by category, in display order —
/// used both for the Dua Detail screen's content and its
/// previous/next navigation within a category.
final Map<String, List<DuaEntry>> mockDuaEntriesByCategory = {
  'Morning Azkar': const [
    DuaEntry(
      id: 'morning_1',
      categoryName: 'Morning Azkar',
      title: 'Morning Remembrance',
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration:
          "Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah",
      translation:
          'We have entered the morning, and with it all sovereignty belongs to Allah. All praise is for '
          'Allah. There is no god but Allah alone, without any partner.',
      reference: 'Sahih Muslim',
    ),
    DuaEntry(
      id: 'morning_2',
      categoryName: 'Morning Azkar',
      title: 'Sayyid al-Istighfar (Master Supplication of Forgiveness)',
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ '
          'وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ '
          'وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      transliteration:
          "Allahumma anta Rabbi la ilaha illa ant, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika "
          "wa wa'dika mastata't, a'udhu bika min sharri ma sana't, abu'u laka bini'matika 'alayya "
          "wa abu'u bidhanbi faghfir li fa innahu la yaghfirudh-dhunuba illa ant",
      translation:
          'O Allah, You are my Lord; there is no god but You. You created me, and I am Your servant, and I '
          'try my best to keep my covenant and promise to You. I seek refuge in You from the evil I have '
          'done. I acknowledge Your favor upon me, and I acknowledge my sin — so forgive me, for none '
          'forgives sins except You.',
      reference: 'Sahih al-Bukhari',
    ),
    DuaEntry(
      id: 'morning_3',
      categoryName: 'Morning Azkar',
      title: 'Protection for the Day',
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ '
          'السَّمِيعُ الْعَلِيمُ',
      transliteration:
          "Bismillahil-ladhi la yadurru ma'as-mihi shay'un fil-ardi wa la fis-sama'i wa huwas-Sami'ul-'Alim",
      translation:
          'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is '
          'the All-Hearing, the All-Knowing.',
      reference:
          'Abu Dawud, at-Tirmidhi (recited three times, morning and evening)',
    ),
  ],
  'Protection': const [
    DuaEntry(
      id: 'protection_1',
      categoryName: 'Protection',
      title: 'Dua for Anxiety and Sorrow',
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ '
          'وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      transliteration:
          "Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, "
          "wa dala'id-dayni wa ghalabatir-rijal",
      translation:
          'O Allah, I seek refuge in You from anxiety and sorrow, from incapacity and laziness, from '
          'cowardice and miserliness, and from being overcome by debt and overpowered by others.',
      reference: 'Sahih al-Bukhari',
    ),
  ],
  'Before Sleeping': const [
    DuaEntry(
      id: 'sleep_1',
      categoryName: 'Before Sleeping',
      title: 'Dua Before Sleeping',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allahumma amutu wa ahya',
      translation: 'In Your name, O Allah, I die and I live.',
      reference: 'Sahih al-Bukhari',
    ),
    DuaEntry(
      id: 'sleep_2',
      categoryName: 'Before Sleeping',
      title: 'Dua for Protection Through the Night',
      arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
      transliteration: "Allahumma qini 'adhabaka yawma tab'athu 'ibadak",
      translation:
          'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
      reference: 'Sunan Abi Dawud, at-Tirmidhi',
    ),
  ],
};
