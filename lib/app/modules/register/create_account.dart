import 'package:flutter/material.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/register/create_account_controller.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/utils/validators.dart';
import 'package:step/app/widgets/texts.dart';

import '../../core/data/shared_preferences/helper_funcs.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/logos.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController registerController;

  @override
  void initState() {
    // TODO: implement initState
    registerController = RegisterController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterForm(
      controller: registerController,
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key, required this.controller});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        height: getScreenHeight(context),
        width: getScreenWidth(context),
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
        child: Column(
          children: [
            getHeightSpace(getTopPadding(context)),
            SizedBox(
                height: 110,
                child: const VocationalAcademyHorizontalRegister()),
            Container(
              color: kOnPrimary,
              height: 1.5,
              width: getScreenWidth(context),
            ),
            Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getHeightSpace(10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getTitleText(
                                getL10(context).welcome,
                                context,
                                color: kOnPrimary,
                              ),
                            ],
                          ),                                                          /// كلمه welcome
                          getHeightSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getTitleText(
                                getL10(context).joinStepAcademy.toUpperCase(),
                                context,
                                color: kOnPrimary,
                              ),
                            ],
                          ),                                                          /// كلمه join step academy
                          getHeightSpace(20),
                          SizedBox(
                            // width: getScreenWidth(context) * 0.4,
                            child: TextFormFieldWidget(
                              title: getL10(context).firstName,
                              controller: controller.studentName_1,
                              validatetor: Validators(context).validateName,
                            ),
                          ),                                                     /// الاسم الاول
                          SizedBox(
                            // width: getScreenWidth(context) * 0.4,
                            child: TextFormFieldWidget(
                              title: getL10(context).lastName,
                              controller: controller.studentName_4,
                              validatetor: Validators(context).validateName,
                            ),
                          ),                                                     /// الاسم الثاني

                          /// contact info
                          getHeightSpace(20),
                          TextFormFieldWidget(
                            title: getL10(context).email,
                            controller: controller.studentEmail,
                            textInputType: TextInputType.emailAddress,
                            validatetor: Validators(context).validateEmail,
                          ),                                          /// حقل الايميل
                          getHeightSpace(20),
                          TextFormFieldWidget(
                            title: getL10(context).phone,
                            controller: controller.studentPhoneNumber_1,
                            textInputType: TextInputType.phone,
                            validatetor: Validators(context).validatePhone,
                          ),                                          /// حقل التليفون
                          getHeightSpace(20),

                          PasswordFormField(
                            title: getL10(context).password,
                            controller: controller.studentPassword,
                            validatetor: (value) {
                              if ((value?.isNotEmpty ?? false) &&
                                  value!.length > 4) {
                                return null;
                              }
                              return getL10(context)
                                  .pleaseEnterValidPaswordLengthMustBeMoreThan4;
                            },
                          ),                                            /// حقل الباسوورد
                          getHeightSpace(20),
                          Center(
                            child: SizedBox(
                                width: getScreenWidth(context) * 0.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black,
                                            offset:Offset(0.1,0.1),
                                            blurRadius: 0.1,
                                            spreadRadius: 0.1
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.cyan
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      controller.register(context);
                                    },
                                    child: Text(
                                      getL10(context).createNewStudentAccount,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                            ),
                          ),                                                       /// زرار ال log in
                          SizedBox(height: 10),                                                                    ///
                          Center(
                            child: SizedBox(
                                width: getScreenWidth(context) * 0.75,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset:Offset(0.1,0.1),
                                          blurRadius: 0.1,
                                          spreadRadius: 0.1
                                      ),],
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.cyan,
                                  ),
                                  child: TextButton(
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                    child:  Text(
                                      getL10(context).cancel,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                            ),
                          ),                                                       /// زرار ال sign up

                          getHeightSpace(10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     getNormalText(
                          //       "Are you a teacher?",
                          //       context,
                          //       color: kPrimaryColor,
                          //       weight: FontWeight.normal,
                          //       size: 16,
                          //     ),
                          //     getWidthSpace(5),
                          //     getNormalText(
                          //       "Join our team!",
                          //       context,
                          //       weight: FontWeight.bold,
                          //       color: kPrimaryColor,
                          //       size: 18,
                          //     ).onTap(() {
                          //       contactUsWhatsapp();
                          //     }),
                          //   ],
                          // ),                                                          /// الصف بتاع هل انت مدرس ؟ سجل معنا
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class CustomRadioSelect extends StatefulWidget {
  const CustomRadioSelect({
    super.key,
    required this.list,
    required this.controller,
  });

  final List<Map<String, String>> list;
  final TextEditingController controller;

  @override
  State<CustomRadioSelect> createState() {
    return _CustomRadioSelectColumnState();
  }
}

class _CustomRadioSelectColumnState extends State<CustomRadioSelect> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: widget.list
            .map(
              (e) => SizedBox(
            // color: getRandomQuietColor().withOpacity(0.5),

            /*     width: (getScreenWidth(context) * (1 - widget.titleWidth)) /
            widget.list.length,*/
            height: 50,
            child: Row(
              children: [
                getWidthSpace(10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: widget.controller.text.toString() ==
                        e["index"].toString()
                        ? kPrimaryColor
                        : kOnPrimary,
                    border: Border.all(color: kOnPrimary),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                getWidthSpace(10),
                getNormalText(
                  e["name"].toString(),
                  context,
                  color: kOnPrimary,
                  weight: FontWeight.bold,
                ),
                getWidthSpace(10),
              ],
            ),
          ).onTap(() {
            setState(() {
              widget.controller.text = e["index"].toString();
            });
          }),
        )
            .toList(),
      ),
    );
  }
}
