import 'package:cliniq/core/api/api_config.dart';
import 'package:cliniq/core/api/socket/socket_service.dart';
import 'package:cliniq/core/api/dummy_api_consumer.dart';
import 'package:cliniq/features/appointments/data/repos_impl/appointments_repo_impl.dart';
import 'package:cliniq/features/appointments/domain/repos/appointments_repo.dart';
import 'package:cliniq/features/chat/data/repos_impl/chat_repo_impl.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:cliniq/features/home/data/repos_impl/home_repo_impl.dart';
import 'package:cliniq/features/home/domain/repos/home_repo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/dio_consumer.dart';
import 'package:cliniq/features/auth/data/repos_impl/auth_repo_impl.dart';
import 'package:cliniq/features/auth/domain/repos/auth_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Connectivity
  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<SocketService>(SocketService());

  // Decide API source
  if (ApiConfig.useDummyApi) {
    getIt.registerSingleton<ApiConsumer>(DummyApiConsumer());
  } else {
    final dio = Dio();
    final dioConsumer = DioConsumer(dio: dio);
    await dioConsumer.init();

    getIt.registerSingleton<Dio>(dio);
    getIt.registerSingleton<ApiConsumer>(dioConsumer);
  }

  // Repos
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(api: getIt<ApiConsumer>()));

  getIt.registerSingleton<HomeRepo>(HomeRepoImpl(api: getIt<ApiConsumer>()));

  getIt.registerSingleton<AppointmentsRepo>(
    AppointmentsRepoImpl(api: getIt<ApiConsumer>()),
  );

  getIt.registerSingleton<ChatRepo>(ChatRepoImpl(api: getIt<ApiConsumer>()));
}
