// import 'package:conditional_builder/conditional_builder.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_messages.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';

import '../../../../network/local/cache_helper.dart';
import '../../../../shared/widgets/components.dart';
import '../../../../shared/widgets/constants.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../../shared/widgets/with_safe_area.dart';
import '../../../../styles/color.dart';
import '../../../../screens/home/home_screen.dart';
import '../view_model/cubit.dart';
import '../view_model/login_states.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
                    key: 'token', value: state.loginModel?.token ?? '')
                .then((value) {
              token = state.loginModel?.token ?? '';
              navigateAndReplace(context, const HomeScreen());
            });
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.get(context);
          return WithSafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PageContainer(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text(
                      AppStrings.login,
                      style: TextStyle(color: Colors.black),
                    ),
                    centerTitle: true,
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                  ),
                  body: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.hello,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 1.h, bottom: 1.h),
                              child: Text(
                                AppStrings.email,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.h),
                          child: defaultFormField(
                            controller: cubit.emailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value == null) {
                                return AppMessgaes.enterYourEmail;
                              }
                            },
                            hintText: AppStrings.email,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 1.h, bottom: 1.h),
                              child: Text(
                                AppStrings.password,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.h),
                          child: defaultFormField(
                            controller: cubit.passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPassword,
                            validate: (value) {
                              if (value == null) {
                                return AppMessgaes.enterYourPass;
                              }
                            },
                            hintText: AppStrings.password,
                            suffix: cubit.suffix,
                            suffixPressed: cubit.changePasswordVisibility,
                          ),
                        ),
                        const Spacer(),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          fallback: (context) =>
                              const CupertinoActivityIndicator(),
                          builder: (context) => Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 2.h),
                            height: 5.h,
                            child: GFButton(
                              color: primaryColor,
                              onPressed: () {
                                if (cubit.formKey.currentState!.validate()) {
                                  // FirebaseMessaging.instance
                                  //     .getToken()
                                  //     .then((token) {
                                  // print('fcm token: $token');
                                  cubit.login(
                                      email: cubit.emailController.text.trim(),
                                      password:
                                          cubit.passwordController.text.trim(),
                                      deviceName: 'deviceName',
                                      fcmToken: token);
                                  // });
                                }
                              },
                              size: GFSize.LARGE,
                              text: AppStrings.login,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                              shape: GFButtonShape.pills,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
