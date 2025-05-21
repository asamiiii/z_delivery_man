import 'package:dartz/dartz.dart';
import 'package:z_delivery_man/core/errors/failure.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';

abstract class QualityManagerRepo {
  Future<Either<Failure, List<ProviderModel>>> getRelatedProviders();
}
