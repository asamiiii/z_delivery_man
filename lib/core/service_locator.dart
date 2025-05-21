import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/repo/quality_manager_repo_imp.dart';
import '../databases/api/dio_consumer.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<DioConsumer>(DioConsumer(dio: getIt<Dio>()));

  getIt.registerSingleton<QualityManagerRepoImp>(
    QualityManagerRepoImp(getIt<DioConsumer>()),
  );
}
