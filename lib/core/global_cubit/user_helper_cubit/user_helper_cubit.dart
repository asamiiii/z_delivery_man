// user_event.dart

import 'package:z_delivery_man/screens/quality_app/providers_list/data/models/provider_model/provider_model.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

// class UserSuccessUpdatedState extends UserState {
//   final Doctor? user;
//   UserSuccessUpdatedState(this.user);
// }

class QualityProviderUserState extends UserState {
  final ProviderModel? provider;
  QualityProviderUserState(this.provider);
}
