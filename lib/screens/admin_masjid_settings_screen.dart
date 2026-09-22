import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/masjid_info_data.dart';
import '../models/mock_data.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/admin_masjid_settings/logo_change_field.dart';
import '../widgets/admin_masjid_settings/settings_text_field.dart';
import '../widgets/admin_masjid_settings/facility_toggle_row.dart';
import '../widgets/admin_prayer_timing/editable_time_field.dart';
import '../widgets/admin_prayer_timing/time_format_utils.dart';

/// Admin Masjid Settings screen: editable profile, Imam contact,
/// facility toggles, Jumu'ah timing, and an About Masjid description.
/// Theme-aware, responsive, UI only — "Save Changes" shows a success
/// snackbar but writes nothing to a backend; all edits are local State
/// and reset when the screen is left.
class AdminMasjidSettingsScreen extends StatefulWidget {
  const AdminMasjidSettingsScreen({super.key});

  @override
  State<AdminMasjidSettingsScreen> createState() => _AdminMasjidSettingsScreenState();
}

class _AdminMasjidSettingsScreenState extends State<AdminMasjidSettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _imamNameController;
  late final TextEditingController _imamContactController;
  late final TextEditingController _aboutController;

  bool _logoChanged = false;
  late Map<String, bool> _facilityEnabled;
  late TimeOfDay _khutbahTime;
  late TimeOfDay _salahTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: MasjidInfo.name);
    _addressController = TextEditingController(text: MasjidInfo.address);
    _phoneController = TextEditingController(text: MasjidInfo.phone);
    _emailController = TextEditingController(text: MasjidInfo.email);
    _imamNameController = TextEditingController(text: MasjidInfo.imamName);
    _imamContactController = TextEditingController(text: MasjidInfo.imamPhone);
    _aboutController = TextEditingController(text: MasjidInfo.aboutText);

    _facilityEnabled = {
      for (final f in MasjidInfo.facilities) f.name: true,
    };

    _khutbahTime = parseTimeLabel(MockData.jumuah.khutbahTime);
    _salahTime = parseTimeLabel(MockData.jumuah.salahTime);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _imamNameController.dispose();
    _imamContactController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _handleChangeLogo() {
    setState(() => _logoChanged = !_logoChanged);
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700)); // mock save
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Masjid settings saved successfully'),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          'Masjid Settings',
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
              // --- Profile ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: palette.divider, width: 1),
                  boxShadow: [
                    BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LogoChangeField(isChanged: _logoChanged, onChangeTap: _handleChangeLogo),
                    const SizedBox(height: 20),
                    SettingsTextField(
                      label: 'Masjid Name',
                      controller: _nameController,
                      icon: Icons.mosque_outlined,
                    ),
                    const SizedBox(height: 14),
                    SettingsTextField(
                      label: 'Address',
                      controller: _addressController,
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    SettingsTextField(
                      label: 'Phone',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    SettingsTextField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // --- Imam ---
              SettingsSection(
                title: 'Imam',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        SettingsTextField(
                          label: 'Imam Name',
                          controller: _imamNameController,
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 14),
                        SettingsTextField(
                          label: 'Imam Contact',
                          controller: _imamContactController,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Facilities ---
              SettingsSection(
                title: 'Facilities',
                children: [
                  for (final facility in MasjidInfo.facilities)
                    FacilityToggleRow(
                      facility: facility,
                      enabled: _facilityEnabled[facility.name] ?? true,
                      onChanged: (v) => setState(() => _facilityEnabled[facility.name] = v),
                    ),
                ],
              ),
              const SizedBox(height: 22),

              // --- Jumu'ah ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.2),
                  boxShadow: [
                    BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: AppColors.goldAccentGradient,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(Icons.groups_rounded, size: 18, color: AppColors.primaryGreenDark),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Jumu'ah",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: EditableTimeField(
                            label: 'KHUTBAH TIME',
                            value: _khutbahTime,
                            onChanged: (t) => setState(() => _khutbahTime = t),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: EditableTimeField(
                            label: 'PRAYER TIME',
                            value: _salahTime,
                            onChanged: (t) => setState(() => _salahTime = t),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // --- About Masjid ---
              SettingsTextField(
                label: 'About Masjid',
                controller: _aboutController,
                icon: Icons.info_outline_rounded,
                maxLines: 5,
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                      : const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}