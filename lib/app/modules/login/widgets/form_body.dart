import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants_and_enums/enums.dart';
import '../../../core/data/shared_preferences/helper_funcs.dart';
import '../../../core/themes/colors.dart';
import '../../../utils/helper_funcs.dart';
import '../../../utils/routing_utils.dart';
import '../../../widgets/form_fields.dart';
import '../../../widgets/texts.dart';
import '../../register/create_account.dart';
import '../login_controller.dart';

class FormBody extends StatelessWidget {
  const FormBody({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kSecondaryColor.withOpacity(0.2),
            kSecondaryColor.withOpacity(0.2),
            kSecondaryColor.withOpacity(0.5),
            kSecondaryColor.withOpacity(0.5),
            kSecondaryColor.withOpacity(0.5),
            kSecondaryColor.withOpacity(0.5),
            kSecondaryColor,
          ],
          // stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // color: getRandomQuietColor(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Center(
                    child: Text(
                      "Welcome !",
                      textAlign: TextAlign.center,
                      style: getThemeData(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(
                        color:
                        getThemeData(context).colorScheme.onPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.5,
                      ),
                    ),
                  ),                                                            /// كلمه welcome
                  getHeightSpace(3),
                  Center(
                    child: Text(
                      "STEP ACADEMY",
                      textAlign: TextAlign.center,
                      style: getThemeData(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(
                        color:
                        getThemeData(context).colorScheme.onPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),                                                             /// كلمه step academy
                  getHeightSpace(getScreenHeight(context) * 0.005),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenSize(context).width * 0.13,
                    ),
                    child: TextFormFieldWidget(
                      title: getL10(context).email,
                      controller: controller.emailController,
                      titleColor: kOnPrimary,
                      heightOfBoty: 35,
                      showCounter: false,
                      // maxLength: 14,
                      textInputType: TextInputType.emailAddress,
                      formatters: [
                        NoSpaceFormatter(),
                      ],
                    ),
                  ),                                                              /// زر ال Email
                  getHeightSpace(getScreenHeight(context) * 0.005),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenSize(context).width * 0.13,
                    ),
                    child: PasswordFormField(
                      title: getL10(context).password,
                      controller: controller.passwordController,
                      titleColor: kOnPrimary,
                      bodyHeight: 40,
                    ),
                  ),                                                              /// زر ال password
                  getHeightSpace(5),

                  /// dont have an account yet text
                  ///
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getNormalText(
                        getL10(context).dontHaveaccountyet,
                        context,
                        color: kOnPrimary,
                        weight: FontWeight.bold,
                        size: 15,
                      ),
                      getWidthSpace(5),
                      getNormalText(
                        getL10(context).createAccount,
                        context,
                        weight: FontWeight.bold,
                        color: Colors.black,
                        size: 15,
                      ).onTap(() {
                        Navigator.of(context)
                            .push(routeToPage(const RegisterPage()));
                      }),
                    ],
                  ),                                                            /// dont have account yet


                  getHeightSpace(getScreenHeight(context) * 0.01),
                  // const Spacer(),


                  LoginButton(controller: controller),                          /// تسجيل الدخول
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getScreenSize(context).width * 0.13,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        maximumSize: Size(
                          getScreenSize(context).width - 30, 100,
                        ),
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            29,
                          ),
                        ),
                        minimumSize: Size(
                          getScreenSize(context).width - 30, 40,
                        ),
                      ),
                      onPressed: () {
                        controller.loginAsGuest(context);
                      },
                      child: Text(
                        getL10(context).loginAsGuest,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),                                /// تسجيل الدخول ك guest
                  ),                                                 /// تسجيل الدخول ك guest

                  /// Are you teacher  join us
                  getHeightSpace(3),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     getNormalText(
                  //       "Are you a teacher?",
                  //       context,
                  //       color: kOnPrimary,
                  //       weight: FontWeight.bold,
                  //       size: 16,
                  //     ),
                  //     getWidthSpace(5),
                  //     getNormalText(
                  //       "Join our team!",
                  //       context,
                  //       weight: FontWeight.bold,
                  //       color: Colors.black,
                  //       size: 16,
                  //     ).onTap(() {
                  //       contactUsWhatsapp();
                  //     }),
                  //   ],
                  // ),                                                    ///كلمه هل انت مدرس انضم معنا
                  //const Spacer(),
                  Center(
                    child: getNormalText(
                      "Contact us",
                      context,
                      weight: FontWeight.bold,
                      color: kOnPrimary,
                    ),
                  ),                                                  /// contact us كلمه

                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)),
                      height: getScreenHeight(context) * 0.05,
                      child:
                      SvgPicture.asset("assets/images/whatsapp_ic.svg"),
                    ),
                  ).onTap(() {                                           /// فانكشن الواتساب
                    contactUsWhatsapp();
                  }),

                  /// allrights reserved text                                  /// كلمه حقوق الطبع والنشر محفوظه
                  ///
                  // const Spacer()
                ],
              ),
            ),
            SizedBox(
              height: getScreenHeight(context) * 0.171,
              child: ValueListenableBuilder(
                  valueListenable: controller.allRightsText,
                  builder: (context, allRights, child) {
                    return Column(
                      children: [
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getNormalText(allRights, context,
                                color:Colors.black, size: 10),
                            getNormalText(
                              " ${controller.allRightsYear}",
                              context,
                              color:Colors.black,
                              size: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 380,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getNormalText(
                                  controller.allRightsCompanyName, context,
                                  color:Colors.black, size: 10),
                              Row(children: [
                                const SizedBox(width: 126,),
                                getNormalText(
                                    controller.allRightsCompanyNameEnglish,
                                    context,
                                    color:Colors.black,
                                    size: 10),
                                const SizedBox(width: 5,),
                                getNormalText(
                                  controller.allRightsLink,
                                  context,
                                  color:Colors.black,
                                  size: 10,
                                ).onTap(() {
                                  launchURL(controller.allRightsLink);
                                }),

                              ]),
                            ],
                          ),
                        ),
                        getHeightSpace(0),
                      ],
                    );
                  }),
            ),
          ],
        ),                                                    /// من اول كلمه welcome  لحد حقوق الطبع والنشر
      ),
    );
  }

  void launchURL(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.controller,
  });

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.state,
        builder: (context, state, child) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getScreenSize(context).width * 0.13,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                maximumSize: Size(
                  getScreenSize(context).width,
                  40,
                ),
                minimumSize: Size(
                  getScreenSize(context).width,
                  40,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(29)),
              ),
              onPressed: () {
                controller.login();
              },
              child: state == AppViewState.busy
                  ? const SizedBox(
                  height: 30,
                  child: CircularProgressIndicator(
                    color: kOnPrimary,
                  ))
                  : getNormalText(getL10(context).login, context,
                  color: kOnPrimary, weight: FontWeight.bold, size: 18),      /// الخط بتاع الكلام اللي في زرار ال login
            ),
          );
        });
  }
}
