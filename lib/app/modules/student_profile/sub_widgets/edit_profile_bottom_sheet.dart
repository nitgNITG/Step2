import 'package:flutter/material.dart';
import 'package:step/app/modules/base/profile_controller.dart';
import 'package:step/app/utils/validators.dart';
import 'package:step/app/widgets/texts.dart';

import '../../../utils/helper_funcs.dart';
import '../../../widgets/form_fields.dart';

class EditProfileBottomSheet extends StatelessWidget {
  const EditProfileBottomSheet({
    super.key,
    required this.controller,
  });

  final BaseProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              getHeightSpace(10),
              getTitleText(
                getL10(
                  context,
                ).editProfile,
                context,
                color: getThemeData(context).colorScheme.onBackground,
              ),
              Container(
                // (MediaQuery.of(context).padding.top) -
                // kToolbarHeight -

                width: getScreenWidth(context),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: getThemeData(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: getScreenWidth(context) * 0.4,
                            child: TextFormFieldWidget(
                              title: getL10(context).firstName,
                              fillColor: Colors.grey.shade400,
                              controller: controller.firstNameController,
                              validatetor: Validators(context).validateName,
                              titleColor: getThemeData(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                          SizedBox(
                            width: getScreenWidth(context) * 0.4,
                            child: TextFormFieldWidget(
                              title: getL10(context).lastName,
                              fillColor: Colors.grey.shade400,
                              validatetor: Validators(context).validateName,
                              controller: controller.lastNameController,
                              titleColor: getThemeData(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                        ],
                      ),
                      getHeightSpace(10),
                      SizedBox(
                        width: getScreenWidth(context) * 0.85,
                        child: Column(
                          children: [
                            TextFormFieldWidget(
                              title: getL10(context).email,
                              validatetor: Validators(context).validateEmail,
                              fillColor: Colors.grey.shade400,
                              controller: controller.emailController,
                              titleColor: getThemeData(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                            getHeightSpace(10),
                            SizedBox(
                              width: getScreenWidth(context) * 0.85,
                              child: TextFormFieldWidget(
                                title: "${getL10(context).phone}1",
                                fillColor: Colors.grey.shade400,
                                validatetor:
                                    Validators(context).validatePhone,
                                controller: controller.phoneController,
                                titleColor: getThemeData(context)
                                    .colorScheme
                                    .onBackground,
                              ),
                            ),
                            getHeightSpace(10),
                            PasswordFormField(
                              title: getL10(context).newPassword,
                              controller: controller.password,
                              fillColor: Colors.grey.shade400,
                              titleColor: getThemeData(context)
                                  .colorScheme
                                  .onBackground,
                              validatetor: (value) {
                                if ((value?.isNotEmpty ?? false) &&
                                    value!.length >= 6) return null;
                                return getL10(context)
                                    .pleaseEnterValidPaswordLengthMustBeMoreThan4;
                              },
                            )
                          ],
                        ),
                      ),
                      getHeightSpace(10),
                    ],
                  ),
                ),
              ),
              // const Spacer(),
              getHeightSpace(20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 125,
                child: Builder(builder: (context) {
                  return OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: getNormalText(
                      getL10(context).cancel,
                      context,
                      color: getThemeData(context).colorScheme.onBackground,
                    ),
                  );
                }),
              ),
              getWidthSpace(10),
              ElevatedButton(
                onPressed: () {
                  controller.updateUserData(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                child: Text(
                  "Save",
                ),
              ),
            ],
          ),
          getHeightSpace(10)
        ],
      ),
    );
  }
}
