import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/modules/base/base_controller.dart';
import 'package:step/app/utils/helper_funcs.dart';

import '../../core/constants_and_enums/enums.dart';
import '../../core/data/api/ApiCall.dart';
import '../../core/data/models/logged_user.dart';
import '../../core/data/shared_preferences/shared_preferences_keys.dart';
import '../../core/data/shared_preferences/sharedpreference_service.dart';
import '../../core/themes/colors.dart';
import '../../widgets/messages.dart';

class BaseProfileController extends BaseController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final thirdNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final phone2Controller = TextEditingController();
  final sientificDegreeController = TextEditingController(text: "1");
  final jobController = TextEditingController();
  final password = TextEditingController();

  final cityController = TextEditingController(text: "1");

  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  updateUserData(context) async {
    if (formKey.currentState!.validate()) {
      try {
        changeViewState(AppViewState.busy);

        final response = await CallApi.getRequest(
          "${StaticData.baseUrl}/signleteacher/apis.php?function=edit_user&token=${getLoggedUser().token}&phone1=${phoneController.text.toString()}&fname=${firstNameController.text.toString()}&lname=${lastNameController.text.toString()}&email=${emailController.text.toString()}&newpassword=${password.text.toString()}",
        );

        if (response['status'] != 'fail') {
          Navigator.of(context).pop();
          saveUser();
          Future.delayed(Duration(milliseconds: 100));
          showSnackBar(context, "Data updated successfully", color: Colors.cyan);

          changeViewState(AppViewState.idle);
        } else {
          showSnackBar(context, getL10(context).tryAgain);
        }
      } catch (e) {
        changeViewState(AppViewState.error);
        print(e.toString());
      }
    }
  }

  void setDataForBottomSheet() {
    firstNameController.text = getLoggedUser().firstName;

    lastNameController.text = getLoggedUser().lastName;

    phoneController.text = getLoggedUser().phone;

    emailController.text = getLoggedUser().email;
  }

  saveUser() async {
    final user = LoggedUser(
      id: getLoggedUser().id,
      username: getLoggedUser().username,
      firstName: firstNameController.text.toString(),
      lastName: lastNameController.text.toString(),
      image: getLoggedUser().image,
      token: getLoggedUser().token,
      email: emailController.text.toString(),
      role: getLoggedUser().role,
      phone: phoneController.text.toString(),
      coursesCount: getLoggedUser().coursesCount,
      isAdmin: getLoggedUser().isAdmin,
    );

    await SharedPreferencesService.instance
        .setString(SharedPreferencesKeys.loggedUser, user.toString());
  }
}
