import 'package:flutter/material.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/add_transaction/cubit/category_cubit.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/app_router.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/localization/localization_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependency injection
  await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: const MyExpensesApp(),
    ),
  );
}

class MyExpensesApp extends StatelessWidget {
  const MyExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<ThemeCubit>()),
          BlocProvider(create: (context) => di.sl<HomeCubit>()),
          BlocProvider(create: (context) => di.sl<CategoryCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'ادارة المصروفات',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: Routes.splash,
              onGenerateRoute: AppRouter.generateRoute,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            );
          },
        ),
      ),
    );
  }
}
