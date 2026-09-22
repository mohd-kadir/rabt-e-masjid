import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/admin_login_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/more/masjid_profile_card.dart';
import '../widgets/more/more_section.dart';
import 'hijri_calendar_screen.dart';
import 'dua_azkar_screen.dart';
import 'qibla_screen.dart';
import 'ramadan_screen.dart';
import 'announcements_screen.dart';
import 'bookmarks_screen.dart';
import 'masjid_info_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
// import 'admin_login_screen.dart';

/// Premium "More" screen: a settings/navigation hub. Masjid profile card
/// up top, then Islamic Tools / Community / Masjid / App sections, each
/// grouped into a rounded card of icon + title + subtitle rows.
/// Theme-aware (light/dark), responsive, UI only.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon')),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 18),
              MasjidProfileCard(
                onTap: () => _push(context, const MasjidInfoScreen()),
              ),
              const SizedBox(height: 26),

              MoreSection(
                title: 'Islamic Tools',
                items: [
                  MoreMenuItem(
                    title: 'Hijri Calendar',
                    subtitle: 'Islamic dates, upcoming events, and moon-sighting adjustment',
                    icon: Icons.calendar_month_rounded,
                    onTap: () => _push(context, const HijriCalendarScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Dua & Azkar',
                    subtitle: 'Morning, evening, and daily supplications',
                    icon: Icons.auto_stories_rounded,
                    onTap: () => _push(context, const DuaAzkarScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Qibla',
                    subtitle: 'Compass direction and distance to Makkah',
                    icon: Icons.explore_rounded,
                    onTap: () => _push(context, const QiblaScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Ramadan',
                    subtitle: 'Sehri, Iftar, Taraweeh timings, and daily progress',
                    icon: Icons.nightlight_round,
                    onTap: () => _push(context, const RamadanScreen()),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              MoreSection(
                title: 'Community',
                items: [
                  MoreMenuItem(
                    title: 'Announcements',
                    subtitle: 'Notices from the mosque administration',
                    icon: Icons.campaign_rounded,
                    onTap: () => _push(context, const AnnouncementsScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Events',
                    subtitle: 'Upcoming lectures, classes, and gatherings',
                    icon: Icons.event_rounded,
                    onTap: () => _comingSoon(context, 'Events'),
                  ),
                  MoreMenuItem(
                    title: 'Bookmarks',
                    subtitle: 'Saved Ayahs, Duas, and announcements',
                    icon: Icons.bookmark_rounded,
                    onTap: () => _push(context, const BookmarksScreen()),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              MoreSection(
                title: 'Masjid',
                items: [
                  MoreMenuItem(
                    title: 'Masjid Information',
                    subtitle: 'Contact details, facilities, and the Imam',
                    icon: Icons.mosque_rounded,
                    onTap: () => _push(context, const MasjidInfoScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Prayer Settings',
                    subtitle: 'Azan alerts, jamaat reminders, and calculation method',
                    icon: Icons.tune_rounded,
                    onTap: () => _comingSoon(context, 'Prayer Settings'),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              MoreSection(
                title: 'App',
                items: [
                  MoreMenuItem(
                    title: 'Notifications',
                    subtitle: 'Prayer alerts and announcement notices',
                    icon: Icons.notifications_none_rounded,
                    onTap: () => _push(context, const NotificationsScreen()),
                  ),
                  MoreMenuItem(
                    title: 'Settings',
                    subtitle: 'App preferences and appearance',
                    icon: Icons.settings_outlined,
                    onTap: () => _push(context, const
                        SettingsScreen()
                  ),
                  ),
                  MoreMenuItem(
                    title: 'About',
                    subtitle: 'App version and information',
                    icon: Icons.info_outline_rounded,
                    onTap: () => _comingSoon(context, 'About'),
                  ),
                  MoreMenuItem(
                    title: 'Masjid Admin Login',
                    subtitle: 'For authorized mosque administrators',
                    icon: Icons.admin_panel_settings_outlined,
                    onTap: () => _push(context, const AdminLoginScreen()
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}