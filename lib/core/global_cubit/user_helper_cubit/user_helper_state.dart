// import 'package:bloc/bloc.dart';
// import 'package:z_delivery_man/core/global_cubit/user_helper_cubit/user_helper_cubit.dart';
// import 'package:z_delivery_man/network/local/user_helper.dart';

// class UserCubit extends Cubit<UserState> {
//   UserCubit() : super(UserInitialState()) {
//     if (UserHelper.getAssistantEntity() != null) {
//       getAssistantUser();
//     } else {
//       getUser();
//     }
//   }

//   int? docId;

//   // Update user data
//   Future<void> updateUser(Doctor? user) async {
//     emit(UserInitialState());

//     // Save the updated user to shared preferences
//     await UserHelper.saveUserEntity(user);

//     // Emit success state with updated user data
//     emit(UserSuccessUpdatedState(user));
//   }

//   // Update user data
//   Future<void> updateAssistantUser(SecondDoctorModel? user) async {
//     emit(UserInitialState());

//     // Save the updated user to shared preferences
//     await UserHelper.saveAssistantDoctorEntity(user);

//     // Emit success state with updated user data
//     emit(UserSuccessUpdatedAssistantDoctorState(user));
//   }

//   // Get user data
//   Future<void> getUser() async {
//     emit(UserInitialState());

//     // Retrieve the user from shared preferences
//     Doctor? user = UserHelper.getUserEntity();

//     if (user != null) {
//       // Emit success state with the retrieved user data
//       emit(UserSuccessUpdatedState(user));
//     }
//   }

//   // Get user data
//   Future<int?> getAssistantUser() async {
//     emit(UserInitialState());

//     // Retrieve the user from shared preferences
//     SecondDoctorModel? user = UserHelper.getAssistantDoctorEntity();

//     if (user != null) {
//       // Emit success state with the retrieved user data

//       emit(UserSuccessUpdatedAssistantDoctorState(user));
//       return user.id;
//     }
//     return null;
//   }
// }
