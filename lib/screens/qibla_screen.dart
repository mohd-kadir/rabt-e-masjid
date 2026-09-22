import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/qibla_viewmodel.dart';
import '../widgets/qibla/qibla_header.dart';
import '../widgets/qibla/location_status_card.dart';
import '../widgets/qibla/qibla_compass.dart';
import '../widgets/qibla/qibla_info_section.dart';
import '../widgets/qibla/calibration_card.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QiblaViewModel(),
      child: const _QiblaScreenContent(),
    );
  }
}

class _QiblaScreenContent extends StatelessWidget {
  const _QiblaScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QiblaViewModel>();
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 20.0;
    final compassSize = (isTablet ? 320.0 : size.width * 0.72).clamp(220.0, 320.0);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QiblaHeader(),
              const SizedBox(height: 16),

              if (viewModel.errorMessage.isNotEmpty)
                _buildErrorCard(viewModel.errorMessage, palette),

              LocationStatusCard(
                locationLabel: viewModel.locationName,
                isLocationEnabled: viewModel.isLocationEnabled,
              ),
              const SizedBox(height: 36),

              if (viewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    QiblaCompass(
                      size: compassSize,
                      qiblaAngleDegrees: viewModel.qiblaAngle,
                      deviceHeading: viewModel.deviceHeading,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 16,
                          color: AppColors.goldLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Gold arrow shows Qibla direction',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.goldLight.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // ✅ Calibration card
              if (viewModel.isCalibrating && !viewModel.isLoading)
                _buildCalibrationCard(palette),

              const SizedBox(height: 36),

              QiblaInfoSection(
                directionDegrees: viewModel.qiblaAngle,
                distanceToMakkah: viewModel.distanceToMakkah,
              ),
              const SizedBox(height: 28),

              // ✅ Calibration button
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: viewModel.isLoading ? null : viewModel.refreshData,
                      icon: viewModel.isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.refresh, size: 18),
                      label: Text(viewModel.isLoading ? 'Loading...' : 'Refresh Location'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _showCalibrationDialog(context),
                      icon: const Icon(Icons.sync, size: 18),
                      label: const Text('Calibrate'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, AppPalette palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationCard(AppPalette palette) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync, color: Colors.orange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Move phone in figure-8 pattern to calibrate compass',
              style: TextStyle(
                fontSize: 12,
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalibrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calibrate Compass'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync, size: 48, color: Colors.orange),
            SizedBox(height: 12),
            Text(
              'Move your phone in a figure-8 pattern (∞) for 3-4 seconds.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'This helps the compass find the correct direction.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}