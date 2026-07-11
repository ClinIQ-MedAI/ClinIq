import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:cliniq/features/appointments/presentation/providers/get_available_doctors_provider.dart';
import 'package:cliniq/features/appointments/presentation/widgets/available_doctors_section.dart';
import 'package:cliniq/features/appointments/presentation/widgets/calendar_timeline.dart';
import 'package:cliniq/features/user/presentation/widgets/profile_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAppointmentsView extends ConsumerStatefulWidget {
  const UserAppointmentsView({super.key});

  @override
  ConsumerState<UserAppointmentsView> createState() =>
      _UserAppointmentsViewState();
}

class _UserAppointmentsViewState extends ConsumerState<UserAppointmentsView> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectAnotherDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(today) ? today : selectedDate,
      firstDate: today,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('yyyy-MM-dd', 'en').format(selectedDate);
    final availableDoctorsAsync = ref.watch(
      getAvailableDoctorsProvider(dateString),
    );

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: ProfileAppBar(
        title: LocaleKeys.bookingTitle,
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalGap(20),
          CalendarTimeline(
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.1),
          const VerticalGap(24),
          Expanded(
            child: AvailableDoctorsSection(
              doctorsAsync: availableDoctorsAsync,
              onSelectAnotherDate: _selectAnotherDate,
            ).animate().fadeIn(delay: 400.ms),
          ),
          const VerticalGap(24),
        ],
      ),
    );
  }
}
