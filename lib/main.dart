import 'package:cliniq/core/providers/socket_lifecycle_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cliniq/core/cubits/app_theme_cubit/app_theme_cubit.dart';
import 'package:cliniq/core/cubits/app_theme_cubit/app_theme_state.dart';
import 'package:cliniq/core/cubits/internet/internet_connection_cubit.dart';
import 'package:cliniq/core/helpers/app_storage_helper.dart';
import 'package:cliniq/core/helpers/on_generate_routes.dart';
import 'package:cliniq/features/splash/presentation/screens/splash_screen.dart';
import 'package:cliniq/core/services/custom_bloc_observer.dart';
import 'package:cliniq/core/services/get_it_service.dart';
import 'package:cliniq/core/utils/app_themes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupGetIt();
  await EasyLocalization.ensureInitialized();
  await AppStorageHelper.init();
  Bloc.observer = CustomBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: ClinIq()),
    ),
  );
}

class ClinIq extends ConsumerStatefulWidget {
  const ClinIq({super.key});

  @override
  ConsumerState<ClinIq> createState() => _ClinIqState();
}

class _ClinIqState extends ConsumerState<ClinIq> {
  late AppThemeCubit appThemeCubit;

  @override
  void initState() {
    super.initState();
    appThemeCubit = AppThemeCubit();
    FlutterNativeSplash.remove();

    ref.read(socketLifecycleProvider).start();
  }

  @override
  void dispose() {
    ref.read(socketLifecycleProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => appThemeCubit),
        BlocProvider(
          create: (context) =>
              InternetConnectionCubit(connectivity: getIt<Connectivity>()),
        ),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(430, 932),
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: appThemeCubit.getTheme(),
                navigatorKey: navigatorKey,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                onGenerateRoute: (settings) =>
                    onGenerateRoutes(settings, context),
                home: const SplashScreen(),
                // builder: kDebugMode
                //     ? (context, child) {
                //         return DeveloperOverlay(child: child!);
                //       }
                //     : null,
              );
            },
          );
        },
      ),
    );
  }
}
