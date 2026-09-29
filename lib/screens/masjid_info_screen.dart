import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../models/masjid_info_data.dart';
import '../widgets/home/section_title.dart';
import '../widgets/masjid_info/masjid_hero.dart';
import '../widgets/masjid_info/masjid_contact_buttons.dart';
import '../widgets/masjid_info/masjid_info_details.dart';
import '../widgets/masjid_info/imam_card.dart';
import '../widgets/masjid_info/facilities_grid.dart';
import '../widgets/masjid_info/today_prayer_summary_strip.dart';

/// Masjid Information screen: hero (photo placeholder + logo + name +
/// location), quick contact actions, address/phone/email, the Imam's
/// profile, facilities, an about section, and today's prayer summary.
/// Theme-aware (light/dark), responsive, UI only, mock data.
class MasjidInfoScreen extends StatefulWidget {
  const MasjidInfoScreen({super.key});

  @override
  State<MasjidInfoScreen> createState() => _MasjidInfoScreenState();
}

class _MasjidInfoScreenState extends State<MasjidInfoScreen> {
  MasjidInfo? _masjidInfo;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMasjidInfo();
  }

  Future<void> _loadMasjidInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      // Get admin profile
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception('Admin profile not found.');
      }

      final adminData = adminDoc.data();

      if (adminData == null) {
        throw Exception('Admin data is empty.');
      }

      final masjidId = adminData['masjidId']?.toString();

      if (masjidId == null || masjidId.isEmpty) {
        throw Exception('Masjid ID not found.');
      }

      // Get masjid information
      final masjidDoc = await FirebaseFirestore.instance
          .collection('masjids')
          .doc(masjidId)
          .get();

      if (!masjidDoc.exists) {
        throw Exception('Masjid information not found.');
      }

      final data = masjidDoc.data();

      if (data == null) {
        throw Exception('Masjid data is empty.');
      }

      final masjidInfo = MasjidInfo.fromFirestore(data);

      debugPrint('MASJID ID: $masjidId');

      debugPrint('MASJID PHOTO URL: ${masjidInfo.photoUrl}');

      if (!mounted) return;

      setState(() {
        _masjidInfo = masjidInfo;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading masjid information: $e');

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showComingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action — coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Masjid Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _masjidInfo == null) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Masjid Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage ?? 'Masjid information not available.',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
        ),
      );
    }

    final masjidInfo = _masjidInfo!;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Masjid Information',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MasjidHero(masjidInfo: masjidInfo),

              // const SizedBox(height: 20),

              // MasjidContactButtons(
              //   onCall: () =>
              //       _showComingSoon(context, 'Calling ${masjidInfo.phone}'),
              //   onDirections: () =>
              //       _showComingSoon(context, 'Opening directions'),
              //   onContact: () =>
              //       _showComingSoon(context, 'Opening contact form'),
              // ),

              const SizedBox(height: 10),

              const SectionTitle(
                title: 'Information',
                icon: Icons.info_outline_rounded,
              ),

              const SizedBox(height: 10),

              MasjidInfoDetails(masjidInfo: masjidInfo),

              const SizedBox(height: 24),

              const SectionTitle(
                title: 'Imam',
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 10),

              ImamCard(masjidInfo: masjidInfo),

              const SizedBox(height: 24),

              const SectionTitle(
                title: 'Facilities',
                icon: Icons.grid_view_rounded,
              ),

              const SizedBox(height: 10),

              FacilitiesGrid(masjidInfo: masjidInfo),

              const SizedBox(height: 24),

              const SectionTitle(
                title: 'About Masjid',
                icon: Icons.mosque_outlined,
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.divider, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  masjidInfo.aboutText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: palette.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const TodayPrayerSummaryStrip(),
            ],
          ),
        ),
      ),
    );
  }
}
