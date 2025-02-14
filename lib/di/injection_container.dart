import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/config/app_config.dart';
import '../core/services/device_service.dart';
import '../core/services/sms_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => AuthBloc(authRepository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dio: sl(),
      deviceService: sl(),
      smsService: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => DeviceService());
  sl.registerLazySingleton(
    () => SMSService(
      twilioAccountSid: AppConfig.twilioAccountSid,
      twilioAuthToken: AppConfig.twilioAuthToken,
      twilioVerifyServiceSid: AppConfig.twilioVerifyServiceSid,
    ),
  );

  // External
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: AppConfig.connectionTimeout),
        receiveTimeout: const Duration(seconds: AppConfig.receiveTimeout),
        sendTimeout: const Duration(seconds: AppConfig.sendTimeout),
        validateStatus: (status) {
          return status != null && status >= 200 && status < 500;
        },
      ),
    );

    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('REQUEST BODY: ${options.data}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('RESPONSE DATA: ${response.data}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print(
                'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            print('ERROR MESSAGE: ${e.message}');
            print('ERROR RESPONSE: ${e.response?.data}');
            return handler.next(e);
          },
        ),
      );
    }

    return dio;
  });
}
