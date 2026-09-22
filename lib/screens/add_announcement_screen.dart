import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../widgets/add_announcement/labeled_field.dart';
import '../widgets/add_announcement/poster_upload_box.dart';

/// Add Announcement screen for the Admin Panel: title, description,
/// category, date, time, an optional poster upload, and an Important
/// toggle. Validates required fields before allowing publish.
/// UI only — no backend call, no real file upload.
class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AnnouncementCategory? _category;
  DateTime? _date;
  TimeOfDay? _time;
  bool _isImportant = false;
  bool _hasPoster = false;
  bool _attemptedSubmit = false;
  bool _isPublishing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? get _categoryError =>
      (_attemptedSubmit && _category == null) ? 'Please select a category' : null;

  String? get _dateError => (_attemptedSubmit && _date == null) ? 'Please select a date' : null;

  String? get _timeError => (_attemptedSubmit && _time == null) ? 'Please select a time' : null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _handlePublish() async {
    setState(() => _attemptedSubmit = true);

    final formValid = _formKey.currentState?.validate() ?? false;
    final allValid = formValid && _category != null && _date != null && _time != null;

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 900)); // mock publish
    if (!mounted) return;
    setState(() => _isPublishing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${_titleController.text.trim()}" published (UI only)')),
    );
    Navigator.of(context).maybePop();
  }

  void _handleCancel() {
    Navigator.of(context).maybePop();
  }

  InputDecoration _fieldDecoration(BuildContext context, {required String hint}) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(14);
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: palette.textSecondary, fontWeight: FontWeight.w400),
      filled: true,
      fillColor: palette.cardSurfaceAlt,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.warning, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.warning, width: 1.6),
      ),
      errorStyle: const TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.12 : 20.0;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, size: 22, color: palette.textPrimary),
          onPressed: _handleCancel,
        ),
        title: Text(
          'New Announcement',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(
                  label: 'Announcement Title',
                  child: TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    style: TextStyle(fontSize: 13.5, color: palette.textPrimary, fontWeight: FontWeight.w500),
                    decoration: _fieldDecoration(context, hint: "e.g. Jumu'ah Prayer Timing"),
                  ),
                ),
                const SizedBox(height: 18),

                LabeledField(
                  label: 'Description',
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                    style: TextStyle(fontSize: 13.5, color: palette.textPrimary, fontWeight: FontWeight.w500),
                    decoration: _fieldDecoration(context, hint: 'Write the announcement details here...'),
                  ),
                ),
                const SizedBox(height: 18),

                LabeledField(
                  label: 'Category',
                  errorText: _categoryError,
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.cardSurfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: _categoryError != null ? Border.all(color: AppColors.warning, width: 1.4) : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AnnouncementCategory>(
                        value: _category,
                        isExpanded: true,
                        hint: Text(
                          'Select category',
                          style: TextStyle(fontSize: 13, color: palette.textSecondary),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen),
                        dropdownColor: palette.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
                        items: [
                          for (final category in AnnouncementCategory.values)
                            DropdownMenuItem(
                              value: category,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(category.icon, size: 15, color: category.badgeColor),
                                  const SizedBox(width: 8),
                                  Text(category.label),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledField(
                        label: 'Date',
                        errorText: _dateError,
                        child: _PickerField(
                          icon: Icons.calendar_today_rounded,
                          value: _date == null ? 'Select date' : _formatDate(_date!),
                          hasValue: _date != null,
                          hasError: _dateError != null,
                          onTap: _pickDate,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LabeledField(
                        label: 'Time',
                        errorText: _timeError,
                        child: _PickerField(
                          icon: Icons.access_time_rounded,
                          value: _time == null ? 'Select time' : _formatTime(_time!),
                          hasValue: _time != null,
                          hasError: _timeError != null,
                          onTap: _pickTime,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                LabeledField(
                  label: 'Upload Poster',
                  required: false,
                  child: PosterUploadBox(
                    hasSelection: _hasPoster,
                    onTap: () => setState(() => _hasPoster = true),
                    onRemove: () => setState(() => _hasPoster = false),
                  ),
                ),
                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: palette.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: palette.divider, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.priority_high_rounded, size: 19, color: AppColors.warning),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Important Announcement',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Highlighted and shown at the top of the list',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: palette.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isImportant,
                        onChanged: (v) => setState(() => _isImportant = v),
                        activeColor: AppColors.primaryGreen,
                        activeTrackColor: AppColors.primaryGreen.withOpacity(0.25),
                        inactiveThumbColor: palette.iconInactive,
                        inactiveTrackColor: palette.divider,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isPublishing ? null : _handleCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: palette.textSecondary,
                          side: BorderSide(color: palette.divider, width: 1.4),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isPublishing ? null : _handlePublish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isPublishing
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                        )
                            : const Text(
                          'Publish Announcement',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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

class _PickerField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: palette.cardSurfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: hasError ? Border.all(color: AppColors.warning, width: 1.4) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: hasValue ? palette.textPrimary : palette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}