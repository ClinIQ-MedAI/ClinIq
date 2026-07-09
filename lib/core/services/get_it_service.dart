import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/api_features.dart';
import 'package:cliniq/core/api/api_selector.dart';
import 'package:cliniq/core/socket/socket_consumer.dart';
import 'package:cliniq/core/socket/socket_io_consumer.dart';
import 'package:cliniq/features/appointments/data/repos_impl/appointments_repo_impl.dart';
import 'package:cliniq/features/appointments/domain/repos/appointments_repo.dart';
import 'package:cliniq/features/chat/data/repos_impl/attachment_repo_impl.dart';
import 'package:cliniq/features/chat/data/repos_impl/chat_repo_impl.dart';
import 'package:cliniq/features/chat/domain/repos/attachment_repo.dart';
import 'package:cliniq/features/chat/domain/repos/chat_repo.dart';
import 'package:cliniq/features/home/data/repos_impl/home_repo_impl.dart';
import 'package:cliniq/features/home/domain/repos/home_repo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:cliniq/features/auth/data/repos_impl/auth_repo_impl.dart';
import 'package:cliniq/features/auth/domain/repos/auth_repo.dart';
import 'package:cliniq/features/user/data/repos_impl/user_repo_impl.dart';
import 'package:cliniq/features/user/domain/repos/user_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Connectivity
  getIt.registerSingleton<Connectivity>(Connectivity());
  final socketConsumer = SocketIoConsumer();
  socketConsumer.init();
  getIt.registerSingleton<SocketConsumer>(socketConsumer);

  ApiSelector.init();

  getIt.registerSingleton<ApiConsumer>(ApiSelector.get(ApiFeatures.auth));

  // Repos
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(api: ApiSelector.get(ApiFeatures.auth)),
  );

  getIt.registerSingleton<HomeRepo>(
    HomeRepoImpl(api: ApiSelector.get(ApiFeatures.home)),
  );

  getIt.registerSingleton<AppointmentsRepo>(
    AppointmentsRepoImpl(api: ApiSelector.get(ApiFeatures.appointments)),
  );

  getIt.registerSingleton<ChatRepo>(
    ChatRepoImpl(
      api: ApiSelector.get(ApiFeatures.chat),
      socket: getIt<SocketConsumer>(),
    ),
  );

  getIt.registerSingleton<UserRepo>(
    UserRepoImpl(api: ApiSelector.get(ApiFeatures.profile)),
  );

  getIt.registerSingleton<AttachmentRepo>(
    AttachmentRepoImpl(api: ApiSelector.get(ApiFeatures.chat)),
  );
}
