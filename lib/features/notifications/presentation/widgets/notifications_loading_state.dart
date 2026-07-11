import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';

class NotificationsLoadingState extends StatelessWidget {
  const NotificationsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }
}
