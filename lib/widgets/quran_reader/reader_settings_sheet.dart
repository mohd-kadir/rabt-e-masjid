import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Content for the reading-tools bottom sheet: Arabic font size +/-,
/// translation & transliteration toggles, dark reading mode, bookmark,
/// share, and copy. All state is lifted to the parent screen via callbacks.
class ReaderSettingsSheet extends StatelessWidget {
  final AppPalette palette;
  final double fontScale;
  final bool showTranslation;
  final bool showTransliteration;
  final bool isDarkReadingMode;
  final bool isBookmarked;
  final VoidCallback onIncreaseFont;
  final VoidCallback onDecreaseFont;
  final ValueChanged<bool> onTranslationToggle;
  final ValueChanged<bool> onTransliterationToggle;
  final ValueChanged<bool> onDarkModeToggle;
  final ValueChanged<bool> onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const ReaderSettingsSheet({
    super.key,
    required this.palette,
    required this.fontScale,
    required this.showTranslation,
    required this.showTransliteration,
    required this.isDarkReadingMode,
    required this.isBookmarked,
    required this.onIncreaseFont,
    required this.onDecreaseFont,
    required this.onTranslationToggle,
    required this.onTransliterationToggle,
    required this.onDarkModeToggle,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: palette.divider, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Reading Tools',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 18),
          
              // Arabic font size controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Arabic Font Size',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
                  ),
                  Row(
                    children: [
                      _RoundIconButton(icon: Icons.remove_rounded, onTap: onDecreaseFont, palette: palette),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 34,
                        child: Text(
                          '${(fontScale * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: palette.goldMuted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _RoundIconButton(icon: Icons.add_rounded, onTap: onIncreaseFont, palette: palette),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Divider(color: palette.divider, height: 28),
          
              _ToggleRow(
                label: 'Show Translation',
                value: showTranslation,
                onChanged: onTranslationToggle,
                palette: palette,
              ),
              const SizedBox(height: 14),
              _ToggleRow(
                label: 'Show Transliteration',
                value: showTransliteration,
                onChanged: onTransliterationToggle,
                palette: palette,
              ),
              const SizedBox(height: 14),
              _ToggleRow(
                label: 'Dark Reading Mode',
                value: isDarkReadingMode,
                onChanged: onDarkModeToggle,
                palette: palette,
              ),
          
              Divider(color: palette.divider, height: 32),
          
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      label: isBookmarked ? 'Bookmarked' : 'Bookmark',
                      onTap: () => onBookmarkToggle(!isBookmarked),
                      palette: palette,
                      active: isBookmarked,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(icon: Icons.ios_share_rounded, label: 'Share', onTap: onShare, palette: palette),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(icon: Icons.copy_rounded, label: 'Copy', onTap: onCopy, palette: palette),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppPalette palette;

  const _RoundIconButton({required this.icon, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cardSurfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 16, color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppPalette palette;

  const _ToggleRow({required this.label, required this.value, required this.onChanged, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryGreen,
          activeTrackColor: AppColors.primaryGreen.withOpacity(0.25),
          inactiveThumbColor: palette.iconInactive,
          inactiveTrackColor: palette.divider,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppPalette palette;
  final bool active;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.palette,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primaryGreen.withOpacity(0.1) : palette.cardSurfaceAlt,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19, color: active ? AppColors.primaryGreen : palette.textSecondary),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.primaryGreen : palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}