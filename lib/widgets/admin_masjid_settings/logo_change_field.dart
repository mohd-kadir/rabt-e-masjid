import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class LogoChangeField extends StatelessWidget {
  final String? photoUrl;
  final bool isUploading;
  final VoidCallback onChangeTap;
  final VoidCallback onDeleteTap;

  const LogoChangeField({
    super.key,
    required this.photoUrl,
    required this.isUploading,
    required this.onChangeTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final hasPhoto =
        photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Row(
      children: [
        // =====================================================
        // PHOTO PREVIEW
        // =====================================================

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: hasPhoto
                    ? null
                    : AppColors.logoGradient,
                color: hasPhoto
                    ? palette.cardSurface
                    : null,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreenDark
                        .withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: hasPhoto
                    ? Image.network(
                  photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: AppColors.primaryGreen,
                      child: const Icon(
                        Icons.mosque_rounded,
                        size: 32,
                        color: AppColors.goldLight,
                      ),
                    );
                  },
                )
                    : const Icon(
                  Icons.mosque_rounded,
                  size: 32,
                  color: AppColors.goldLight,
                ),
              ),
            ),

            // =================================================
            // UPLOAD LOADING
            // =================================================

            if (isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            // =================================================
            // CAMERA BUTTON
            // =================================================

            Positioned(
              right: -2,
              bottom: -2,
              child: Material(
                color: AppColors.gold,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: isUploading
                      ? null
                      : onChangeTap,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 15,
                      color: AppColors.primaryGreenDark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        // =====================================================
        // PHOTO INFORMATION
        // =====================================================

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Masjid Photo',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                isUploading
                    ? 'Uploading photo...'
                    : hasPhoto
                    ? 'Current masjid photo'
                    : 'No photo selected. Default logo is being used.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary,
                ),
              ),

              const SizedBox(height: 8),

              // =================================================
              // BUTTONS
              // =================================================

              Row(
                children: [
                  OutlinedButton(
                    onPressed: isUploading
                        ? null
                        : onChangeTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      AppColors.primaryGreen,
                      side: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.2,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      hasPhoto
                          ? 'Change Photo'
                          : 'Add Photo',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // =================================================
                  // DELETE BUTTON
                  // =================================================

                  if (hasPhoto) ...[
                    const SizedBox(width: 8),

                    OutlinedButton(
                      onPressed: isUploading
                          ? null
                          : onDeleteTap,
                      style:
                      OutlinedButton.styleFrom(
                        foregroundColor:
                        AppColors.warning,
                        side: BorderSide(
                          color: AppColors.warning
                              .withOpacity(0.6),
                          width: 1.2,
                        ),
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}