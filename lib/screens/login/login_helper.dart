import 'package:flutter/material.dart';
import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/home/home_delivery/home_delivery.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/login/condition_navigator.dart';
import 'package:z_delivery_man/screens/login/login_states.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/shared/widgets/constants.dart';

class LoginHelper {
  //* show Messages to notify user with Login state.
  static loginStateValidation(BuildContext context, LoginStates state) {
    if (state is LoginSuccessState) {
      debugPrint('User Type : ${state.loginModel?.type}');
      CacheHelper.saveData(key: 'token', value: state.loginModel?.token ?? '')
          .then((value) {
        token = state.loginModel?.token ?? '';
        // debugPrint('token = $token');
        if (token!.isNotEmpty) {
          debugPrint('token 1 = $token');
          navigateAndReplace(context, userHome(state.loginModel?.type ?? ''));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('من فضلك تأكد من بياناتك'),
            backgroundColor: Colors.red,
          ));
          debugPrint('token 2 = $token');
        }
      });
    } else if (state is LoginFailedState) {
      showToast(
        message: 'Login Failed',
        state: ToastStates.ERROR,
      );
    }
  }
}
