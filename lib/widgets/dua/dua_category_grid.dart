import 'package:flutter/material.dart';
import '../../models/dua_data.dart';
import 'dua_category_card.dart';

/// Responsive grid of Dua category cards — 2 columns on phones,
/// widening on tablets.
class DuaCategoryGrid extends StatelessWidget {
  final List<DuaCategory> categories;
  final ValueChanged<DuaCategory>? onCategoryTap;

  const DuaCategoryGrid({super.key, required this.categories, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 700 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return DuaCategoryCard(
              category: category,
              onTap: onCategoryTap == null ? null : () => onCategoryTap!(category),
            );
          },
        );
      },
    );
  }
}