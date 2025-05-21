import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_delivery_man/network/local/user_helper.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/data/repo/quality_manger_repo.dart';
import 'package:z_delivery_man/screens/quality_app/providers_list/presentation/manager/fetch_provides_cubit/fetch_providers_state.dart';

class FetchProvidersCubit extends Cubit<FetchProvidersState> {
  FetchProvidersCubit(this.qualityManagerRepo) : super(FetchProvidersInitial()){
    fetchRelatedDoctors();
  }

  int? selectedDocId;
  List<ProviderModel> doctors = [];

  final QualityManagerRepo qualityManagerRepo;

  Future<void> fetchRelatedDoctors() async {
    emit(FetchProvidersLoading());
    final res = await qualityManagerRepo.getRelatedProviders();

    res.fold((failure) => emit(FetchProvidersError(failure.message)), (docs) {
      doctors = docs;
      emit(const FetchProvidersSuccess());
    });
  }

  setSelectedDocId(ProviderModel? provider) {
    selectedDocId = provider?.providerId;
    UserHelper.saveProviderId(provider?.providerId);
    UserHelper.saveProviderEntity(provider);

    emit(FetchProvidersInitial());
  }
}
