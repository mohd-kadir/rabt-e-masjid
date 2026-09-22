import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Confirmation dialog shown before deleting an announcement.
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;

  const DeleteConfirmationDialog({super.key, required this.title});

  static Future<bool> show(BuildContext context, {required String title}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(title: title),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dialog(
      backgroundColor: palette.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded, size: 24, color: AppColors.warning),
            ),
            const SizedBox(height: 16),
            Text(
              'Delete Announcement?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'This will permanently remove "$title". This action cannot be undone.',
              style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.textSecondary,
                      side: BorderSide(color: palette.divider, width: 1.4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}