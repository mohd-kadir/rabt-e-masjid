import 'package:flutter/material.dart';
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
class MasjidInfoScreen extends StatelessWidget {
  const MasjidInfoScreen({super.key});

  void _showComingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action — coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Masjid Information',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MasjidHero(),
              const SizedBox(height: 20),
              MasjidContactButtons(
                onCall: () => _showComingSoon(context, 'Calling ${MasjidInfo.phone}'),
                onDirections: () => _showComingSoon(context, 'Opening directions'),
                onContact: () => _showComingSoon(context, 'Opening contact form'),
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Information', icon: Icons.info_outline_rounded),
              const SizedBox(height: 10),
              const MasjidInfoDetails(),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Imam', icon: Icons.person_outline_rounded),
              const SizedBox(height: 10),
              const ImamCard(),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Facilities', icon: Icons.grid_view_rounded),
              const SizedBox(height: 10),
              const FacilitiesGrid(),
              const SizedBox(height: 24),
              const SectionTitle(title: 'About Masjid', icon: Icons.mosque_outlined),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.divider, width: 1),
                  boxShadow: [
                    BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Text(
                  MasjidInfo.aboutText,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: palette.textSecondary, height: 1.6),
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