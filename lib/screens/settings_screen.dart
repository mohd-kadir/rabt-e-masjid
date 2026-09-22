import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/settings_data.dart';
import '../widgets/hijri_calendar/hijri_adjustment_control.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/settings/settings_switch_row.dart';
import '../widgets/settings/settings_select_row.dart';
import '../widgets/settings/settings_radio_row.dart';
import '../widgets/settings/settings_static_row.dart';
import '../widgets/settings/settings_dropdown_row.dart';
import '../widgets/settings/selection_bottom_sheet.dart';
import '../widgets/settings/font_size_bottom_sheet.dart';

/// Complete Settings screen: Appearance, Prayer, Quran, Hijri, Language,
/// Notifications, and About — each grouped into a rounded card, using a
/// deliberate mix of switches, an inline dropdown, inline radio groups,
/// and bottom sheets. Theme-aware, UI only; every preference here is
/// local State and resets when the screen is left (no persistence).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Appearance
  AppThemeMode _themeMode = AppThemeMode.system;

  // Prayer
  String _calculationMethod = prayerCalculationMethods.first;
  Madhab _madhab = Madhab.shafi;
  bool _azanNotifications = true;
  bool _prayerReminders = true;
  bool _jamaatTimings = true;

  // Quran
  double _arabicFontScale = 1.0;
  bool _translationEnabled = true;
  bool _transliterationEnabled = false;
  QuranReadingMode _readingMode = QuranReadingMode.light;

  // Hijri
  int _hijriAdjustment = 0;

  // Language
  AppLanguage _language = AppLanguage.english;

  // Notifications
  bool _announcementNotifications = true;
  bool _prayerNotifications = true;
  bool _importantNotices = true;

  void _showInfoDialog(String title, String body) {
    final palette = context.palette;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: palette.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: palette.textPrimary)),
        content: Text(body, style: TextStyle(fontSize: 13, color: palette.textSecondary, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
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
          'Settings',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--- Appearance ---
              SettingsSection(
                title: 'Appearance',
                children: [
                  for (final mode in AppThemeMode.values)
                    SettingsRadioRow(
                      title: mode.label,
                      selected: _themeMode == mode,
                      onTap: () => setState(() => _themeMode = mode),
                    ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Prayer ---
              SettingsSection(
                title: 'Prayer',
                children: [
                  SettingsDropdownRow(
                    icon: Icons.calculate_outlined,
                    title: 'Calculation Method',
                    value: _calculationMethod,
                    options: prayerCalculationMethods,
                    onChanged: (v) => setState(() => _calculationMethod = v),
                  ),
                  SettingsSelectRow(
                    icon: Icons.balance_outlined,
                    title: 'Madhab',
                    value: _madhab.label,
                    onTap: () => SelectionBottomSheet.show(
                      context,
                      title: 'Madhab',
                      options: Madhab.values.map((m) => m.label).toList(),
                      selected: _madhab.label,
                      onSelect: (v) => setState(
                            () => _madhab = Madhab.values.firstWhere((m) => m.label == v),
                      ),
                    ),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.notifications_active_outlined,
                    title: 'Azan Notifications',
                    subtitle: 'Alert at the start of each prayer time',
                    value: _azanNotifications,
                    onChanged: (v) => setState(() => _azanNotifications = v),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.alarm_outlined,
                    title: 'Prayer Reminders',
                    subtitle: 'Reminder shortly before each prayer',
                    value: _prayerReminders,
                    onChanged: (v) => setState(() => _prayerReminders = v),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.groups_outlined,
                    title: 'Jamaat Timings',
                    subtitle: 'Show congregation times alongside Azan',
                    value: _jamaatTimings,
                    onChanged: (v) => setState(() => _jamaatTimings = v),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Quran ---
              SettingsSection(
                title: 'Quran',
                children: [
                  SettingsSelectRow(
                    icon: Icons.format_size_rounded,
                    title: 'Arabic Font Size',
                    value: '${(_arabicFontScale * 100).round()}%',
                    onTap: () => FontSizeBottomSheet.show(
                      context,
                      initialScale: _arabicFontScale,
                      onChanged: (v) => setState(() => _arabicFontScale = v),
                    ),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.translate_rounded,
                    title: 'Translation',
                    subtitle: 'Show English translation beneath each Ayah',
                    value: _translationEnabled,
                    onChanged: (v) => setState(() => _translationEnabled = v),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.abc_rounded,
                    title: 'Transliteration',
                    subtitle: 'Show Latin-script transliteration',
                    value: _transliterationEnabled,
                    onChanged: (v) => setState(() => _transliterationEnabled = v),
                  ),
                  SettingsSelectRow(
                    icon: Icons.menu_book_rounded,
                    title: 'Reading Mode',
                    value: _readingMode.label,
                    onTap: () => SelectionBottomSheet.show(
                      context,
                      title: 'Reading Mode',
                      options: QuranReadingMode.values.map((m) => m.label).toList(),
                      selected: _readingMode.label,
                      onSelect: (v) => setState(
                            () => _readingMode = QuranReadingMode.values.firstWhere((m) => m.label == v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Hijri ---
              SettingsSection(
                title: 'Hijri',
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: HijriAdjustmentControl(
                      value: _hijriAdjustment,
                      onChanged: (v) => setState(() => _hijriAdjustment = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Language ---
              SettingsSection(
                title: 'Language',
                children: [
                  SettingsSelectRow(
                    icon: Icons.language_rounded,
                    title: 'App Language',
                    value: _language.label,
                    onTap: () => SelectionBottomSheet.show(
                      context,
                      title: 'Language',
                      options: AppLanguage.values.map((l) => l.label).toList(),
                      selected: _language.label,
                      onSelect: (v) => setState(
                            () => _language = AppLanguage.values.firstWhere((l) => l.label == v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Notifications ---
              SettingsSection(
                title: 'Notifications',
                children: [
                  SettingsSwitchRow(
                    icon: Icons.campaign_outlined,
                    title: 'Announcements',
                    subtitle: 'Notices from the mosque administration',
                    value: _announcementNotifications,
                    onChanged: (v) => setState(() => _announcementNotifications = v),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.mosque_outlined,
                    title: 'Prayer Notifications',
                    subtitle: 'Azan and Jamaat alerts',
                    value: _prayerNotifications,
                    onChanged: (v) => setState(() => _prayerNotifications = v),
                  ),
                  SettingsSwitchRow(
                    icon: Icons.priority_high_rounded,
                    title: 'Important Notices',
                    subtitle: 'Urgent alerts from the masjid',
                    value: _importantNotices,
                    onChanged: (v) => setState(() => _importantNotices = v),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- About ---
              SettingsSection(
                title: 'About',
                children: [
                  SettingsNavRow(
                    icon: Icons.info_outline_rounded,
                    title: 'About Rabt-e-Masjid',
                    onTap: () => _showInfoDialog(
                      'About Rabt-e-Masjid',
                      'Rabt-e-Masjid connects you to your local masjid — prayer times, Quran, Duas, '
                          'announcements, and community tools, all in one place.',
                    ),
                  ),
                  SettingsNavRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _showInfoDialog(
                      'Privacy Policy',
                      'This is a UI-only demo build. A full privacy policy will be published here before release.',
                    ),
                  ),
                  SettingsNavRow(
                    icon: Icons.description_outlined,
                    title: 'Terms',
                    onTap: () => _showInfoDialog(
                      'Terms of Use',
                      'This is a UI-only demo build. Full terms of use will be published here before release.',
                    ),
                  ),
                  const SettingsStaticRow(
                    icon: Icons.tag_rounded,
                    title: 'App Version',
                    value: appVersion,
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