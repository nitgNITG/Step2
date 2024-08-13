import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/login/login_controller.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:flutter/material.dart';

import '../../utils/triangle_painter.dart';
import '../../widgets/logos.dart';
import 'widgets/form_body.dart';
import 'widgets/vocational_logo_and_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;

  @override
  void initState() {
    controller = LoginController();
    controller.getAllRightReserverved();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginController>(
      injectedObject: controller,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 270,
                width: getScreenSize(context).width,
                child:  VocationalAcademyHorizontalRegister(),
              ),
              Container(
                color: kOnPrimary,
                height: 1.5,
                width: getScreenWidth(context),
              ),
              FormBody(controller: controller),                              /// الفورم بتاع ال body
            ],
          ),
        ),
      ),
    );
  }
}
