import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/constants/app_images.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_messages.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';
import 'package:z_delivery_man/styles/color.dart';
//! 
class HelloTxt extends StatelessWidget {
  const HelloTxt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

//* Email Text Field Section
class EmailTextField extends StatelessWidget {
  const EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 1.h, bottom: 1.h),
              child: Text(
                AppStrings.email,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
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
      ],
    );
  }
}

//* Password Text filed section
class PassTextFeild extends StatelessWidget {
  const PassTextFeild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 1.h, bottom: 1.h),
              child: Text(
                AppStrings.password,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
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
      ],
    );
  }
}


class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 2.h),
      height: 7.h,
      child: GFButton(
        color: primaryColor,
        onPressed: () {
          if (cubit.formKey.currentState!.validate()) {
            if (cubit.passwordController.text.isEmpty ||
                cubit.emailController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('تأكد من ادخالك البريد الالكتروني وكلمه المرور'),
                backgroundColor: Colors.red,
              ));
            } else {
              FirebaseMessaging.instance.getToken().then((token) {
                debugPrint('fcm token: $token');
                cubit.login(
                    email: cubit.emailController.text.trim(),
                    password: cubit.passwordController.text.trim(),
                    deviceName: 'deviceName',
                    fcmToken: token);
              });
            }
          }
        },
        size: GFSize.LARGE,
        text: AppStrings.login,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        shape: GFButtonShape.pills,
      ),
    );
  }
}


//* Image on the top of Login screen.
class LoginTopImage extends StatelessWidget {
  const LoginTopImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssetsImages.loginImage,
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.fill,
    );
  }
}
