import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:z_delivery_man/core/errors/failure.dart';
import 'package:z_delivery_man/databases/api/api_consumer.dart';
import 'package:z_delivery_man/network/end_points.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/repo/quality_manger_repo.dart';

class QualityManagerRepoImp implements QualityManagerRepo {
  final ApiConsumer apiConsumer;

  QualityManagerRepoImp(this.apiConsumer);

  @override
  Future<Either<Failure, List<ProviderModel>>> getRelatedProviders() async {
    try {
      var data = await apiConsumer.get(
        EndPoints.GET_Providers,
      );

      var providerResponse = data as List;
      var providerList = providerResponse.map((model) {
        try {
          return ProviderModel.fromJson(model);
        } catch (e) {
          rethrow;
        }
      }).toList();

      return right(providerList);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
