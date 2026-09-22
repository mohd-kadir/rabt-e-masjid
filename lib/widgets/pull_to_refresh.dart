import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;

  const PullToRefresh({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppDataProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        await appData.refreshData();
      },
      child: child,
    );
  }
}