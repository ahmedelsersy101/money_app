import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/cubit/theme_cubit.dart';
import '../../features/language_theme_selection/cubit/setup_cubit.dart';
import '../../features/add_transaction/cubit/category_cubit.dart';
import '../../features/home/cubit/home_cubit.dart';
import '../network/network_info.dart';
import '../api/api_interceptors.dart';
import '../config/app_config.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    // Add pretty logger in debug mode
    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true),
      );
    }

    return dio;
  });

  //! Feature - Theme
  sl.registerFactory(() => ThemeCubit(sharedPreferences: sl()));

  //! Feature - Setup
  sl.registerFactory(() => SetupCubit(sharedPreferences: sl()));

  //! Feature - Home
  sl.registerFactory(() => HomeCubit(sharedPreferences: sl()));

  //! Feature - Category
  sl.registerLazySingleton(() => CategoryCubit(sharedPreferences: sl()));
}
