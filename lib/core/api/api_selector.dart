import 'package:cliniq/core/api/api_config.dart';
import 'package:cliniq/core/api/api_consumer.dart';
import 'package:cliniq/core/api/dio_consumer.dart';
import 'package:cliniq/core/api/dummy_api_consumer.dart';
import 'package:cliniq/core/services/get_it_service.dart';
import 'package:dio/dio.dart';

class ApiSelector {
  static const String dummyApiConsumerInstanceName = 'dummyApiConsumer';
  static const String realApiConsumerInstanceName = 'realApiConsumer';

  static void init() {
    getIt.registerSingleton<ApiConsumer>(
      DummyApiConsumer(),
      instanceName: dummyApiConsumerInstanceName,
    );

    final dio = Dio();
    final dioConsumer = DioConsumer(dio: dio);
    dioConsumer.init();

    getIt.registerSingleton<Dio>(dio);
    getIt.registerSingleton<ApiConsumer>(
      dioConsumer,
      instanceName: realApiConsumerInstanceName,
    );
  }

  static ApiConsumer get(bool useRealApi) {
    final useDummyApi = ApiConfig.useDummyApi || !useRealApi;

    return getIt<ApiConsumer>(
      instanceName: useDummyApi
          ? dummyApiConsumerInstanceName
          : realApiConsumerInstanceName,
    );
  }
}
