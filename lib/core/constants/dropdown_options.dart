import 'package:cliniq/core/models/bottom_nav_item.dart';
import 'package:cliniq/core/utils/app_svgs.dart';

class DropdownOptions {
  static const List<String> genderOptions = [
    'Male',
    'Female',
  ];

  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const List<String> insuranceCompanies = [
    'Aetna',
    'Blue Cross Blue Shield',
    'Cigna',
    'UnitedHealthcare',
    'Humana',
    'Kaiser Permanente',
    'Medicare',
    'Medicaid',
    'Other',
  ];

  static const List<BottomNavItem> bottomNavItems = [
    BottomNavItem(icon: AppSvgs.homeIcon),
    BottomNavItem(icon: AppSvgs.calendarIcon),
    BottomNavItem(icon: AppSvgs.chatIcon),
    BottomNavItem(icon: AppSvgs.profileIcon),
  ];
}
