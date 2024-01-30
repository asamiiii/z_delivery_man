import 'package:flutter/material.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/login/main_widgets.dart';
import 'package:z_delivery_man/screens/login/nested_widgets.dart';
import '../../../../shared/widgets/page_container.dart';
import '../../../../shared/widgets/with_safe_area.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WithSafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PageContainer(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                AppStrings.login,
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [LoginTopImage(), LoginForm()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
