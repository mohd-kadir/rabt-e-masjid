import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItemData({required this.label, required this.icon, required this.activeIcon});
}

const List<NavItemData> kNavItems = [
  NavItemData(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
  NavItemData(
    label: 'Quran',
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
  ),
  NavItemData(
    label: 'Prayer',
    icon: Icons.mosque_outlined,
    activeIcon: Icons.mosque_rounded,
  ),
  NavItemData(
    label: 'Tasbeeh',
    icon: Icons.fingerprint,
    activeIcon: Icons.fingerprint,
  ),
  NavItemData(label: 'More', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded),
];

/// Bottom navigation bar: Home, Quran, Prayer, Tasbeeh, More.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < kNavItems.length; i++)
                Expanded(
                  child: _NavButton(
                    data: kNavItems[i],
                    selected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({required this.data, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryGreen : AppColors.iconInactive;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                selected ? data.activeIcon : data.icon,
                key: ValueKey(selected),
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: selected ? 16 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}