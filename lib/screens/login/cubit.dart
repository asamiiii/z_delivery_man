import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/auth_model/login_model.dart';
import '../../../../network/end_points.dart';
import '../../../../network/local/cache_helper.dart';
import '../../../../network/remote/dio_helper.dart';
import '../../../../shared/widgets/constants.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginModel? loginModel;
  bool? isDeliveyMan;
  void login({
    required String? email,
    required String? password,
    required String? deviceName,
    required String? fcmToken,
  }) async {
    emit(LoginLoadingState());
    await DioHelper.postData(url: LOGIN, data: {
      'email': email,
      'password': password,
      'device_name': deviceName,
      'fcm_token': fcmToken
    }).then((value) async {
      
      loginModel = LoginModel.fromJson(value.data);
      debugPrint(' login resp : ${value.data}');
      if(value.data.toString().contains('errors')){
      emit(LoginFailedState());
      }else{
       isDeliveyMan = loginModel?.type == deliveryMan;
      
      debugPrint('user token : ${loginModel?.token}');
      await CacheHelper.saveData(key: 'name', value:loginModel?.name );
      await CacheHelper.saveData(
              key: 'type', value: (loginModel?.type == 'delivery_man'))
          .then((value) {
        
      });
      emit(LoginSuccessState(loginModel: loginModel));
      }
      
    }).catchError((e) {
      print(e);
      emit(LoginFailedState());
    });
  }
  // show and off the password

  IconData suffix = Icons.remove_red_eye_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword
        ? Icons.remove_red_eye_outlined
        : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
    debugPrint('isPassword : $isPassword');
  }
}
