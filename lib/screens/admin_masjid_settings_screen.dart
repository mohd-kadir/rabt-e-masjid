import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import '../models/masjid_info_data.dart';
import '../models/mock_data.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/admin_masjid_settings/logo_change_field.dart';
import '../widgets/admin_masjid_settings/settings_text_field.dart';
import '../widgets/admin_masjid_settings/facility_toggle_row.dart';
import '../widgets/admin_prayer_timing/editable_time_field.dart';
import '../widgets/admin_prayer_timing/time_format_utils.dart';
import '../services/cloudinary_service.dart';
import 'admin_login_screen.dart';

/// Admin Masjid Settings screen for managing:
/// - Masjid profile
/// - Masjid photo
/// - Imam information
/// - Facilities
/// - Jumu'ah timings
/// - About Masjid
class AdminMasjidSettingsScreen extends StatefulWidget {
  const AdminMasjidSettingsScreen({super.key});

  @override
  State<AdminMasjidSettingsScreen> createState() =>
      _AdminMasjidSettingsScreenState();
}

class _AdminMasjidSettingsScreenState extends State<AdminMasjidSettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _imamNameController;
  late final TextEditingController _imamContactController;
  late final TextEditingController _imamBioController;
  late final TextEditingController _aboutController;

  late Map<String, bool> _facilityEnabled;

  late TimeOfDay _khutbahTime;
  late TimeOfDay _salahTime;

  bool _isSaving = false;
  bool _isLoading = true;
  bool _isUploadingPhoto = false;

  String? _masjidId;
  String? _masjidPhotoUrl;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _imamNameController = TextEditingController();
    _imamContactController = TextEditingController();
    _imamBioController = TextEditingController();
    _aboutController = TextEditingController();

    _facilityEnabled = {
      'Wudu Area': true,
      'Parking': true,
      "Women's Prayer Area": true,
      'Wheelchair Access': true,
      'Islamic Library': true,
    };

    _khutbahTime = parseTimeLabel(MockData.jumuah.khutbahTime);

    _salahTime = parseTimeLabel(MockData.jumuah.salahTime);

    _loadMasjidSettings();
  }

  // ============================================================
  // LOAD MASJID SETTINGS
  // ============================================================

  Future<void> _loadMasjidSettings() async {
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

      _masjidId = masjidId;

      // Get masjid document
      final masjidDoc = await FirebaseFirestore.instance
          .collection('masjids')
          .doc(masjidId)
          .get();

      if (!masjidDoc.exists) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final data = masjidDoc.data();

      if (data == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      // ========================================================
      // BASIC INFORMATION
      // ========================================================

      _nameController.text = data['name']?.toString() ?? '';

      _addressController.text = data['address']?.toString() ?? '';

      _phoneController.text = data['phone']?.toString() ?? '';

      _emailController.text = data['email']?.toString() ?? '';

      // ========================================================
      // MASJID PHOTO
      // ========================================================

      final photoUrl = data['photoUrl']?.toString();

      _masjidPhotoUrl = photoUrl != null && photoUrl.isNotEmpty
          ? photoUrl
          : null;

      // ========================================================
      // IMAM
      // ========================================================

      _imamNameController.text = data['imamName']?.toString() ?? '';

      _imamContactController.text = data['imamContact']?.toString() ?? '';

      _imamBioController.text = data['imamBio']?.toString() ?? '';

      // ========================================================
      // ABOUT
      // ========================================================

      _aboutController.text = data['about']?.toString() ?? '';

      // ========================================================
      // FACILITIES
      // ========================================================

      final facilitiesData = data['facilities'];

      if (facilitiesData is Map) {
        for (final key in _facilityEnabled.keys) {
          final value = facilitiesData[key];

          if (value is bool) {
            _facilityEnabled[key] = value;
          }
        }
      }

      // ========================================================
      // JUMUAH
      // ========================================================

      if (data['khutbahTime'] != null) {
        _khutbahTime = parseTimeLabel(data['khutbahTime'].toString());
      }

      if (data['salahTime'] != null) {
        _salahTime = parseTimeLabel(data['salahTime'].toString());
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading masjid settings: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load masjid settings: $e')),
      );
    }
  }

  // ============================================================
  // FACILITIES
  // ============================================================

  List<MasjidFacility> get _facilities => [
    const MasjidFacility(name: 'Wudu Area', icon: Icons.water_drop_outlined),
    const MasjidFacility(name: 'Parking', icon: Icons.local_parking_outlined),
    const MasjidFacility(
      name: "Women's Prayer Area",
      icon: Icons.groups_outlined,
    ),
    const MasjidFacility(
      name: 'Wheelchair Access',
      icon: Icons.accessible_outlined,
    ),
    const MasjidFacility(
      name: 'Islamic Library',
      icon: Icons.local_library_outlined,
    ),
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _imamNameController.dispose();
    _imamContactController.dispose();
    _imamBioController.dispose();
    _aboutController.dispose();

    super.dispose();
  }

  // ============================================================
  // CHANGE MASJID PHOTO
  // ============================================================

  Future<void> _handleChangeLogo() async {
    if (_masjidId == null || _masjidId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masjid information not available.')),
      );

      return;
    }

    if (_isUploadingPhoto) {
      return;
    }

    try {
      final picker = ImagePicker();

      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );

      // User cancelled image selection
      if (pickedImage == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = true;
      });

      final imageFile = File(pickedImage.path);

      // ========================================================
      // UPLOAD TO CLOUDINARY
      // ========================================================

      final imageUrl = await CloudinaryService.uploadImage(
        imageFile: imageFile,
        folder: 'rabt_masjid/masjid_photos',
      );

      // ========================================================
      // GET CURRENT ADMIN
      // ========================================================

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      // ========================================================
      // SAVE CLOUDINARY URL TO FIRESTORE
      // ========================================================

      await FirebaseFirestore.instance
          .collection('masjids')
          .doc(_masjidId)
          .set({
            'photoUrl': imageUrl,
            'updatedBy': user.uid,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        _masjidPhotoUrl = imageUrl;
        _isUploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masjid photo uploaded successfully.')),
      );
    } catch (e) {
      debugPrint('Masjid photo upload error: $e');

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload masjid photo: $e')),
      );
    }
  }

  // ============================================================
  // REMOVE MASJID PHOTO
  // ============================================================

  Future<void> _handleRemovePhoto() async {
    if (_masjidId == null || _masjidId!.isEmpty) {
      return;
    }

    if (_isUploadingPhoto) {
      return;
    }

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Photo'),
          content: const Text(
            'Are you sure you want to remove the masjid photo?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldRemove != true) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      await FirebaseFirestore.instance
          .collection('masjids')
          .doc(_masjidId)
          .set({
            'photoUrl': FieldValue.delete(),
            'updatedBy': user.uid,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        _masjidPhotoUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masjid photo removed. Default logo will be used.'),
        ),
      );
    } catch (e) {
      debugPrint('Masjid photo remove error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove masjid photo: $e')),
      );
    }
  }

  // ============================================================
  // SAVE MASJID SETTINGS
  // ============================================================

  Future<void> _handleSave() async {
    if (_masjidId == null || _masjidId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masjid information not available.')),
      );

      return;
    }

    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      // ========================================================
      // RE-CHECK ADMIN PROFILE
      // ========================================================

      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception('Admin profile not found.');
      }

      final adminData = adminDoc.data();

      if (adminData == null ||
          adminData['role'] != 'admin' ||
          adminData['masjidId']?.toString() != _masjidId) {
        throw Exception('You are not authorized to update this masjid.');
      }

      // ========================================================
      // SAVE TO FIRESTORE
      // ========================================================

      await FirebaseFirestore.instance.collection('masjids').doc(_masjidId).set(
        {
          // BASIC INFORMATION
          'name': _nameController.text.trim(),
          'address': _addressController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),

          // MASJID PHOTO
          'photoUrl': _masjidPhotoUrl,

          // IMAM
          'imamName': _imamNameController.text.trim(),
          'imamContact': _imamContactController.text.trim(),
          'imamBio': _imamBioController.text.trim(),

          // ABOUT
          'about': _aboutController.text.trim(),

          // FACILITIES
          'facilities': _facilityEnabled,

          // JUMUAH
          'khutbahTime': _formatTime(_khutbahTime),
          'salahTime': _formatTime(_salahTime),

          // EXTRA INFORMATION
          'masjidId': _masjidId,
          'updatedBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error saving masjid settings: $e');

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save masjid settings: $e')),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout from the admin account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.of(context).pop(); // Settings remove
      Navigator.of(context).pop(); // Dashboard remove

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AdminLoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // BUILD
  // ============================================================

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),

        title: Text(
          'Masjid Settings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  24,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // PROFILE
                    // ==================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: palette.cardSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: palette.divider, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // MASJID PHOTO
                          LogoChangeField(
                            photoUrl: _masjidPhotoUrl,
                            isUploading: _isUploadingPhoto,
                            onChangeTap: _handleChangeLogo,
                            onDeleteTap: _handleRemovePhoto,
                          ),

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

                    // ==================================================
                    // IMAM
                    // ==================================================
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

                              const SizedBox(height: 14),

                              SettingsTextField(
                                label: 'Imam Bio',
                                controller: _imamBioController,
                                icon: Icons.info_outline_rounded,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // FACILITIES
                    // ==================================================
                    SettingsSection(
                      title: 'Facilities',
                      children: [
                        for (final facility in _facilities)
                          FacilityToggleRow(
                            facility: facility,
                            enabled: _facilityEnabled[facility.name] ?? true,
                            onChanged: (v) => setState(
                              () => _facilityEnabled[facility.name] = v,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // JUMUAH
                    // ==================================================
                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: palette.cardSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
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

                                child: const Icon(
                                  Icons.groups_rounded,
                                  size: 18,
                                  color: AppColors.primaryGreenDark,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Text(
                                "Jumu'ah",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: palette.textPrimary,
                                ),
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
                                  onChanged: (t) =>
                                      setState(() => _khutbahTime = t),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: EditableTimeField(
                                  label: 'PRAYER TIME',
                                  value: _salahTime,
                                  onChanged: (t) =>
                                      setState(() => _salahTime = t),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // ABOUT MASJID
                    // ==================================================
                    SettingsTextField(
                      label: 'About Masjid',
                      controller: _aboutController,
                      icon: Icons.info_outline_rounded,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // SAVE BUTTON
                    // ==================================================
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primaryGreen
                              .withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // LOGOUT
                    // ==================================================
                    SizedBox(
                      width: double.infinity,

                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,

                        icon: const Icon(Icons.logout_rounded, size: 18),

                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: BorderSide(
                            color: AppColors.warning.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
