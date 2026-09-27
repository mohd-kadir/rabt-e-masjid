import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../widgets/add_announcement/labeled_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final String? announcementId;

  const AddAnnouncementScreen({
    super.key,
    this.announcementId,
  });

  @override
  State<AddAnnouncementScreen> createState() =>
      _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState
    extends State<AddAnnouncementScreen> {

  final _formKey = GlobalKey<FormState>();

  final _titleController =
  TextEditingController();

  final _descriptionController =
  TextEditingController();

  AnnouncementCategory? _category;

  DateTime? _date;

  TimeOfDay? _time;

  bool _isImportant = false;

  bool _attemptedSubmit = false;

  bool _isPublishing = false;

  bool _isLoading = false;

  bool get _isEditMode =>
      widget.announcementId != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      _loadAnnouncement();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // Errors
  // --------------------------------------------------

  String? get _categoryError =>
      (_attemptedSubmit && _category == null)
          ? 'Please select a category'
          : null;

  String? get _dateError =>
      (_attemptedSubmit && _date == null)
          ? 'Please select a date'
          : null;

  String? get _timeError =>
      (_attemptedSubmit && _time == null)
          ? 'Please select a time'
          : null;

  // --------------------------------------------------
  // Load Existing Announcement
  // --------------------------------------------------

  Future<void> _loadAnnouncement() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('announcements')
          .doc(widget.announcementId)
          .get();

      if (!doc.exists) {
        throw Exception(
          'Announcement not found.',
        );
      }

      final data = doc.data();

      if (data == null) {
        throw Exception(
          'Announcement data not found.',
        );
      }

      // -------------------------------
      // Category
      // -------------------------------

      final categoryString =
      data['category']?.toString();

      AnnouncementCategory? category;

      for (final value
      in AnnouncementCategory.values) {
        if (value.name == categoryString) {
          category = value;
          break;
        }
      }

      // -------------------------------
      // Date
      // -------------------------------

      DateTime? date;

      final firestoreDate =
      data['date'];

      if (firestoreDate is Timestamp) {
        date = firestoreDate.toDate();
      }

      // -------------------------------
      // Time
      // -------------------------------

      TimeOfDay? time;

      final timeString =
      data['time']?.toString();

      if (timeString != null &&
          timeString.isNotEmpty) {
        time = _parseTime(timeString);
      }

      if (!mounted) return;

      setState(() {
        _titleController.text =
            data['title']?.toString() ?? '';

        _descriptionController.text =
            data['message']?.toString() ?? '';

        _category = category;

        _date = date;

        _time = time;

        _isImportant =
            data['isImportant'] ?? false;

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load announcement: $e',
          ),
        ),
      );
    }
  }

  // --------------------------------------------------
  // Parse Time
  // --------------------------------------------------

  TimeOfDay? _parseTime(String value) {
    try {
      final parts = value.split(' ');

      if (parts.length != 2) {
        return null;
      }

      final timeParts =
      parts[0].split(':');

      if (timeParts.length != 2) {
        return null;
      }

      int hour =
      int.parse(timeParts[0]);

      final minute =
      int.parse(timeParts[1]);

      final period =
      parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) {
        hour += 12;
      }

      if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (_) {
      return null;
    }
  }

  // --------------------------------------------------
  // Pick Date
  // --------------------------------------------------

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,

      initialDate:
      _date ?? now,

      firstDate:
      now.subtract(
        const Duration(days: 1),
      ),

      lastDate:
      now.add(
        const Duration(days: 730),
      ),

      builder:
          (context, child) => Theme(
        data:
        Theme.of(context).copyWith(
          colorScheme:
          Theme.of(context)
              .colorScheme
              .copyWith(
            primary:
            AppColors.primaryGreen,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  // --------------------------------------------------
  // Pick Time
  // --------------------------------------------------

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,

      initialTime:
      _time ?? TimeOfDay.now(),

      builder:
          (context, child) => Theme(
        data:
        Theme.of(context).copyWith(
          colorScheme:
          Theme.of(context)
              .colorScheme
              .copyWith(
            primary:
            AppColors.primaryGreen,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _time = picked;
      });
    }
  }

  // --------------------------------------------------
  // Format Date
  // --------------------------------------------------

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${d.day} '
        '${months[d.month - 1]} '
        '${d.year}';
  }

  // --------------------------------------------------
  // Format Time
  // --------------------------------------------------

  String _formatTime(TimeOfDay t) {
    final hour =
    t.hourOfPeriod == 0
        ? 12
        : t.hourOfPeriod;

    final minute =
    t.minute
        .toString()
        .padLeft(2, '0');

    final period =
    t.period == DayPeriod.am
        ? 'AM'
        : 'PM';

    return '$hour:$minute $period';
  }

  // --------------------------------------------------
  // Publish / Update
  // --------------------------------------------------

  Future<void> _handlePublish() async {
    setState(() {
      _attemptedSubmit = true;
    });

    final formValid =
        _formKey.currentState
            ?.validate() ??
            false;

    final allValid =
        formValid &&
            _category != null &&
            _date != null &&
            _time != null;

    if (!allValid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isPublishing = true;
    });

    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception(
          'Admin is not logged in.',
        );
      }

      // --------------------------------
      // Get Admin
      // --------------------------------

      final adminDoc =
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception(
          'Admin profile not found.',
        );
      }

      final adminData =
      adminDoc.data();

      final role =
      adminData?['role'];

      final masjidId =
      adminData?['masjidId'];

      if (role != 'admin' ||
          masjidId == null ||
          masjidId
              .toString()
              .isEmpty) {
        throw Exception(
          'Admin setup is incomplete.',
        );
      }

      // --------------------------------
      // Announcement Data
      // --------------------------------

      final announcementData = {
        'title':
        _titleController.text.trim(),

        'message':
        _descriptionController
            .text
            .trim(),

        'category':
        _category!.name,

        'date':
        Timestamp.fromDate(_date!),

        'time':
        _formatTime(_time!),

        'isImportant':
        _isImportant,

        'isActive':
        true,

        'masjidId':
        masjidId.toString(),

        'createdBy':
        user.uid,
      };

      // --------------------------------
      // ADD
      // --------------------------------

      if (!_isEditMode) {
        await FirebaseFirestore.instance
            .collection('announcements')
            .add({
          ...announcementData,

          'createdAt':
          FieldValue.serverTimestamp(),
        });
      }

      // --------------------------------
      // EDIT
      // --------------------------------

      else {
        await FirebaseFirestore.instance
            .collection('announcements')
            .doc(widget.announcementId)
            .update(
          announcementData,
        );
      }

      if (!mounted) return;

      setState(() {
        _isPublishing = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Announcement updated successfully'
                : '"${_titleController.text.trim()}" published successfully',
          ),
        ),
      );

      // true means successfully saved
      Navigator.of(context).pop(true);

    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        _isPublishing = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Firebase error: '
                '${e.message ?? 'Something went wrong.'}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isPublishing = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString()
                .replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // --------------------------------------------------
  // Cancel
  // --------------------------------------------------

  void _handleCancel() {
    Navigator.of(context).maybePop();
  }

  // --------------------------------------------------
  // Field Decoration
  // --------------------------------------------------

  InputDecoration _fieldDecoration(
      BuildContext context, {
        required String hint,
      }) {
    final palette =
        context.palette;

    final borderRadius =
    BorderRadius.circular(14);

    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        fontSize: 13,
        color:
        palette.textSecondary,
        fontWeight:
        FontWeight.w400,
      ),

      filled: true,

      fillColor:
      palette.cardSurfaceAlt,

      contentPadding:
      const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 14,
      ),

      border:
      OutlineInputBorder(
        borderRadius:
        borderRadius,
        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        borderRadius,
        borderSide:
        BorderSide.none,
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        borderRadius,
        borderSide:
        const BorderSide(
          color:
          AppColors.primaryGreen,
          width: 1.6,
        ),
      ),

      errorBorder:
      OutlineInputBorder(
        borderRadius:
        borderRadius,
        borderSide:
        const BorderSide(
          color:
          AppColors.warning,
          width: 1.4,
        ),
      ),

      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        borderRadius,
        borderSide:
        const BorderSide(
          color:
          AppColors.warning,
          width: 1.6,
        ),
      ),

      errorStyle:
      const TextStyle(
        fontSize: 11,
        color:
        AppColors.warning,
        fontWeight:
        FontWeight.w600,
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final palette =
        context.palette;

    final size =
        MediaQuery.of(context).size;

    final isTablet =
        size.width >= 600;

    final horizontalPadding =
    isTablet
        ? size.width * 0.12
        : 20.0;

    return Scaffold(
      backgroundColor:
      palette.background,

      appBar: AppBar(
        backgroundColor:
        palette.background,

        elevation: 0,

        centerTitle: true,

        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 22,
            color:
            palette.textPrimary,
          ),
          onPressed:
          _handleCancel,
        ),

        title: Text(
          _isEditMode
              ? 'Edit Announcement'
              : 'New Announcement',

          style: TextStyle(
            fontSize: 17,
            fontWeight:
            FontWeight.w700,
            color:
            palette.textPrimary,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: _isLoading

        // Loading
            ? const Center(
          child:
          CircularProgressIndicator(),
        )

        // Form
            : Form(
          key: _formKey,

          child:
          SingleChildScrollView(
            padding:
            EdgeInsets.fromLTRB(
              horizontalPadding,
              8,
              horizontalPadding,
              24,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                // -------------------------
                // Title
                // -------------------------

                LabeledField(
                  label:
                  'Announcement Title',

                  child:
                  TextFormField(
                    controller:
                    _titleController,

                    textCapitalization:
                    TextCapitalization
                        .sentences,

                    autovalidateMode:
                    AutovalidateMode
                        .onUserInteraction,

                    validator: (v) =>
                    (v == null ||
                        v.trim()
                            .isEmpty)
                        ? 'Title is required'
                        : null,

                    style:
                    TextStyle(
                      fontSize: 13.5,
                      color:
                      palette
                          .textPrimary,
                      fontWeight:
                      FontWeight.w500,
                    ),

                    decoration:
                    _fieldDecoration(
                      context,
                      hint:
                      "e.g. Jumu'ah Prayer Timing",
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // -------------------------
                // Description
                // -------------------------

                LabeledField(
                  label:
                  'Description',

                  child:
                  TextFormField(
                    controller:
                    _descriptionController,

                    maxLines: 5,

                    textCapitalization:
                    TextCapitalization
                        .sentences,

                    autovalidateMode:
                    AutovalidateMode
                        .onUserInteraction,

                    validator: (v) =>
                    (v == null ||
                        v.trim()
                            .isEmpty)
                        ? 'Description is required'
                        : null,

                    style:
                    TextStyle(
                      fontSize: 13.5,
                      color:
                      palette
                          .textPrimary,
                      fontWeight:
                      FontWeight.w500,
                    ),

                    decoration:
                    _fieldDecoration(
                      context,
                      hint:
                      'Write the announcement details here...',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // -------------------------
                // Category
                // -------------------------

                LabeledField(
                  label:
                  'Category',

                  errorText:
                  _categoryError,

                  child:
                  Container(
                    decoration:
                    BoxDecoration(
                      color:
                      palette
                          .cardSurfaceAlt,

                      borderRadius:
                      BorderRadius
                          .circular(
                          14),

                      border:
                      _categoryError !=
                          null
                          ? Border.all(
                        color:
                        AppColors
                            .warning,
                        width:
                        1.4,
                      )
                          : null,
                    ),

                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 14,
                    ),

                    child:
                    DropdownButtonHideUnderline(
                      child:
                      DropdownButton<
                          AnnouncementCategory>(
                        value:
                        _category,

                        isExpanded:
                        true,

                        hint:
                        Text(
                          'Select category',
                          style:
                          TextStyle(
                            fontSize:
                            13,
                            color:
                            palette
                                .textSecondary,
                          ),
                        ),

                        icon:
                        const Icon(
                          Icons
                              .keyboard_arrow_down_rounded,
                          color:
                          AppColors
                              .primaryGreen,
                        ),

                        dropdownColor:
                        palette
                            .cardSurface,

                        borderRadius:
                        BorderRadius
                            .circular(
                            14),

                        style:
                        TextStyle(
                          fontSize:
                          13.5,
                          fontWeight:
                          FontWeight
                              .w600,
                          color:
                          palette
                              .textPrimary,
                        ),

                        items: [
                          for (final category
                          in AnnouncementCategory
                              .values)
                            DropdownMenuItem(
                              value:
                              category,

                              child:
                              Row(
                                mainAxisSize:
                                MainAxisSize
                                    .min,

                                children: [
                                  Icon(
                                    category
                                        .icon,
                                    size:
                                    15,
                                    color:
                                    category
                                        .badgeColor,
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Text(
                                    category
                                        .label,
                                  ),
                                ],
                              ),
                            ),
                        ],

                        onChanged:
                            (v) {
                          setState(() {
                            _category =
                                v;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // -------------------------
                // Date + Time
                // -------------------------

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Expanded(
                      child:
                      LabeledField(
                        label:
                        'Date',

                        errorText:
                        _dateError,

                        child:
                        _PickerField(
                          icon:
                          Icons
                              .calendar_today_rounded,

                          value:
                          _date == null
                              ? 'Select date'
                              : _formatDate(
                            _date!,
                          ),

                          hasValue:
                          _date != null,

                          hasError:
                          _dateError !=
                              null,

                          onTap:
                          _pickDate,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                      LabeledField(
                        label:
                        'Time',

                        errorText:
                        _timeError,

                        child:
                        _PickerField(
                          icon:
                          Icons
                              .access_time_rounded,

                          value:
                          _time == null
                              ? 'Select time'
                              : _formatTime(
                            _time!,
                          ),

                          hasValue:
                          _time != null,

                          hasError:
                          _timeError !=
                              null,

                          onTap:
                          _pickTime,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // -------------------------
                // Important
                // -------------------------

                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),

                  decoration:
                  BoxDecoration(
                    color:
                    palette.cardSurface,

                    borderRadius:
                    BorderRadius
                        .circular(
                        16),

                    border:
                    Border.all(
                      color:
                      palette.divider,
                      width: 1,
                    ),
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 38,
                        height: 38,

                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .warning
                              .withOpacity(
                              0.1),

                          borderRadius:
                          BorderRadius
                              .circular(
                              11),
                        ),

                        child:
                        const Icon(
                          Icons
                              .priority_high_rounded,
                          size: 19,
                          color:
                          AppColors
                              .warning,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              'Important Announcement',

                              style:
                              TextStyle(
                                fontSize:
                                13.5,
                                fontWeight:
                                FontWeight
                                    .w700,
                                color:
                                palette
                                    .textPrimary,
                              ),
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            Text(
                              'Highlighted and shown at the top of the list',

                              style:
                              TextStyle(
                                fontSize:
                                11,
                                fontWeight:
                                FontWeight
                                    .w500,
                                color:
                                palette
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Switch(
                        value:
                        _isImportant,

                        onChanged:
                            (v) {
                          setState(() {
                            _isImportant =
                                v;
                          });
                        },

                        activeColor:
                        AppColors
                            .primaryGreen,

                        activeTrackColor:
                        AppColors
                            .primaryGreen
                            .withOpacity(
                            0.25),

                        inactiveThumbColor:
                        palette
                            .iconInactive,

                        inactiveTrackColor:
                        palette.divider,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // -------------------------
                // Buttons
                // -------------------------

                Row(
                  children: [

                    Expanded(
                      child:
                      OutlinedButton(
                        onPressed:
                        _isPublishing
                            ? null
                            : _handleCancel,

                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          palette
                              .textSecondary,

                          side:
                          BorderSide(
                            color:
                            palette
                                .divider,
                            width:
                            1.4,
                          ),

                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 15,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),
                        ),

                        child:
                        const Text(
                          'Cancel',

                          style:
                          TextStyle(
                            fontSize:
                            14,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      flex: 2,

                      child:
                      ElevatedButton(
                        onPressed:
                        _isPublishing
                            ? null
                            : _handlePublish,

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          AppColors
                              .primaryGreen,

                          foregroundColor:
                          Colors.white,

                          disabledBackgroundColor:
                          AppColors
                              .primaryGreen
                              .withOpacity(
                              0.6),

                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 15,
                          ),

                          elevation: 0,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),
                        ),

                        child:
                        _isPublishing

                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            2.2,
                            color:
                            Colors.white,
                          ),
                        )

                            : Text(
                          _isEditMode
                              ? 'Save Changes'
                              : 'Publish Announcement',

                          style:
                          const TextStyle(
                            fontSize:
                            14,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// Picker Field
// ======================================================

class _PickerField
    extends StatelessWidget {

  final IconData icon;

  final String value;

  final bool hasValue;

  final bool hasError;

  final VoidCallback onTap;

  const _PickerField({
    required this.icon,
    required this.value,
    required this.hasValue,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context) {

    final palette =
        context.palette;

    return InkWell(
      onTap: onTap,

      borderRadius:
      BorderRadius.circular(14),

      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        decoration:
        BoxDecoration(
          color:
          palette.cardSurfaceAlt,

          borderRadius:
          BorderRadius.circular(14),

          border: hasError
              ? Border.all(
            color:
            AppColors.warning,
            width: 1.4,
          )
              : null,
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: 17,
              color:
              AppColors.primaryGreen,
            ),

            const SizedBox(
              width: 8,
            ),

            Expanded(
              child: Text(
                value,

                overflow:
                TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 12.5,

                  fontWeight:
                  FontWeight.w600,

                  color: hasValue
                      ? palette
                      .textPrimary
                      : palette
                      .textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}