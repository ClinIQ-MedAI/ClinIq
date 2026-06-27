import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:flutter/material.dart';

class ChatLoadingState extends StatelessWidget {
  const ChatLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colorScheme.primary),
    );
  }
}
