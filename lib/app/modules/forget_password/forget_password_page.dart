import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/widgets/form_fields.dart';
import 'package:step/app/widgets/texts.dart';
import 'package:flutter/material.dart';

import '../../widgets/logos.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: getScreenHeight(context),
            width: getScreenWidth(context),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff03396b),
                  Color(0xff1269B3),
                  Color(0xff0d74c9)
                ],
                // stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getHeightSpace(MediaQuery.of(context).padding.top),
                  const VocationalAcademyHorizontalRegister(
                    heightPercent: 0.1,
                  ),
                  const Divider(
                    color: kOnPrimary,
                    thickness: 1,
                  ),
                  Image.asset(
                    "assets/images/forgot_password.png",
                    height: 200,
                  ),
                  getHeightSpace(20),
                  getTitleText(
                    getL10(context).forgetPAssword,
                    context,
                    color: kOnPrimary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getNormalText(
                      """لإعادة تعيين كلمة المرور، أدخل الرقم القومي الخاص بك في الأسفل. سيتم مراسلتك على البريد الإلكتروني في حال إيجادك في قاعدة البيانات، مع تعليمات عن كيفية الدخول مجددًا.""",
                      color: kOnPrimary,
                      weight: FontWeight.bold,
                      context,
                    ),
                  ),
                  getHeightSpace(
                    20,
                  ),
                  getTitleText(
                    "البحث في قاعده البيانات",
                    context,
                    color: kOnPrimary,
                  ),
                  getHeightSpace(10),
                  SizedBox(
                    width: getScreenWidth(context) * 0.8,
                    child: TextFormFieldWidget(
                      title: getL10(context).nationalIdNumber,
                    ),
                  ),
                  getHeightSpace(10),
                  SizedBox(
                    width: getScreenWidth(context) * 0.8,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text(getL10(context).search)),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            child: Container(
              height: getScreenHeight(context),
              // color: Colors.amber.withOpacity(0.8),
              alignment: Alignment.bottomCenter,
              /*    child: getNormalText(
                "asd",
                context,
                color: kOnPrimary,
              ), */
            ),
          )
        ],
      ),
    );
  }
}
