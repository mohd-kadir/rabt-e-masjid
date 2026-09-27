import 'dart:io';

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PosterUploadBox extends StatelessWidget {
  final File? selectedFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PosterUploadBox({
    super.key,
    required this.selectedFile,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    // --------------------------------------------------
    // Image selected
    // --------------------------------------------------
    if (selectedFile != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.cardSurfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: palette.divider,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Image preview
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedFile!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedFile!.path.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Ready to upload',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 19,
                color: AppColors.warning,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------
    // No image selected
    // --------------------------------------------------
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: DottedBorderBox(
        palette: palette,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 22,
                  color: AppColors.primaryGreen,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Tap to upload poster',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'PNG or JPG, up to 5MB (optional)',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed border box
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  final AppPalette palette;

  const DottedBorderBox({
    super.key,
    required this.child,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: palette.divider,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: palette.cardSurfaceAlt,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      const Radius.circular(16),
    );

    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = distance + dashWidth;

        canvas.drawPath(
          metric.extractPath(
            distance,
            next.clamp(0, metric.length),
          ),
          paint,
        );

        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant _DashedBorderPainter oldDelegate,
      ) {
    return oldDelegate.color != color;
  }
}