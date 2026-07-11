import 'package:cliniq/core/constants/locale_keys.dart';
import 'package:cliniq/core/utils/app_text_styles.dart';
import 'package:cliniq/core/utils/app_theme_extension.dart';
import 'package:cliniq/core/utils/validators.dart';
import 'package:cliniq/core/widgets/custom_button.dart';
import 'package:cliniq/core/widgets/custom_text_form_field.dart';
import 'package:cliniq/core/widgets/vertical_gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthDatePickWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final IconData? icon;
  final String? initialDateText;

  const BirthDatePickWidget({
    super.key,
    required this.onDateSelected,
    this.icon,
    this.initialDateText,
  });

  @override
  State<BirthDatePickWidget> createState() => _BirthDatePickWidgetState();
}

class _BirthDatePickWidgetState extends State<BirthDatePickWidget> {
  late final TextEditingController _controller;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDateText ?? '');
    if (widget.initialDateText != null && widget.initialDateText!.isNotEmpty) {
      try {
        selectedDate = DateFormat('dd-MM-yyyy').parse(widget.initialDateText!);
      } catch (_) {
        try {
          selectedDate = DateTime.parse(widget.initialDateText!);
          _controller.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
        } catch (_) {}
      }
    }
  }

  void _showCupertinoPicker(BuildContext context) {
    DateTime tempPickedDate = DateTime(2000);

    showModalBottomSheet(
      backgroundColor: context.inputTheme.backgroundColor,
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            height: 350.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              color: context.inputTheme.backgroundColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: AppTextStyles.getTextStyle(
                          18,
                        ).copyWith(color: context.textPalette.primaryColor),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      backgroundColor: context.inputTheme.backgroundColor,
                      initialDateTime: DateTime(2000),
                      minimumDate: DateTime(1900),
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (DateTime newDate) {
                        tempPickedDate = newDate;
                      },
                    ),
                  ),
                ),
                const VerticalGap(32),
                CustomButton(
                  text: LocaleKeys.signupUserBirthDateButton,
                  onPressed: () {
                    setState(() {
                      selectedDate = tempPickedDate;

                      _controller.text = DateFormat(
                        'dd-MM-yyyy',
                      ).format(tempPickedDate);
                    });

                    widget.onDateSelected(tempPickedDate);

                    Navigator.pop(context);
                  },
                ),
                const VerticalGap(32),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.signupUserBirthDate.tr(),
          style: AppTextStyles.getTextStyle(16).copyWith(
            fontWeight: FontWeight.w600,
            color: context.textPalette.primaryColor,
          ),
        ),
        const VerticalGap(16),
        CustomTextFormField(
          controller: _controller,
          onTap: () => _showCupertinoPicker(context),
          validator: Validators.validateBirthDate,
          hintText: LocaleKeys.signupUserBirthDateHint,
          keyboardType: TextInputType.datetime,
          suffixIcon: Icon(
            widget.icon ?? Icons.calendar_month,
            color: context.colorScheme.onSurface,
            size: 24,
          ),
          readOnly: true,
          focusedBorderWidth: 0,
        ),
      ],
    );
  }
}
