import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/core/constants/app_images.dart';
import 'package:z_delivery_man/core/main_helpers.dart/ui_helper.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';
import 'package:z_delivery_man/screens/login/login_helper.dart';
import 'package:z_delivery_man/screens/login/login_states.dart';
import 'package:z_delivery_man/screens/login/nested_widgets.dart';



//* This is login form , contains userName & Password textField.
class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        LoginHelper.loginStateValidation(context, state);
      },
      builder: (context, state) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: cubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            /* All Reused Widgets in this Column , exist
             in the nested_widget File. */
            children: [
              //* مرحبا
              const HelloTxt(),
              VSpace(2.h),
              const EmailTextField(),
              VSpace(3.h),
              // ignore: prefer_const_constructors
              PassTextFeild(),
              VSpace(30),

              ConditionalBuilder(
                  condition: state is! LoginLoadingState,
                  fallback: (context) => const CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                  builder: (context) => const LoginButton()),
              // VSpace(3.h)
            ],
          ),
        ),
      ),
    );
  }
}
