import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/data/api/ApiCall.dart';
import 'package:step/app/core/data/shared_preferences/shared_preferences_keys.dart';
import 'package:step/app/core/data/shared_preferences/sharedpreference_service.dart';
import 'package:step/app/modules/base/base_controller.dart';
import 'package:step/app/widgets/messages.dart';
import 'package:flutter/material.dart';

import '../../core/constants_and_enums/static_data.dart';
import '../../core/data/shared_preferences/helper_funcs.dart';
import '../../utils/routing_utils.dart';
import '../home/home.dart';

class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ValueNotifier<String> allRightsText = ValueNotifier("");
  String allRightsCompanyName = "";
  String allRightsYear = "";
  String allRightsCompanyNameEnglish = "";
  String allRightsLink = "";


  void login() async {
    changeViewState(AppViewState.busy);

    try {
      const deviceId = "123";
      final respose = await CallApi.getRequest(
          "${StaticData
              .baseUrl}/signleteacher/apis.php?device_id=$deviceId&function=login&password=${passwordController
              .text.toString()}&email=${emailController.text.toString()}");

      if (respose["status"] == "success") {
        SharedPreferencesService.instance
            .setBool(SharedPreferencesKeys.userTypeIsGust, false);

        await saveToSharedPref(respose["data"]);

        changeViewState(AppViewState.idle);
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.of(context!).pushAndRemoveUntil(
          routeToPage(
            HomeMainParentPage(),
          ),
              (c) => false,
        );
      } else {
        changeViewState(AppViewState.idle);
        showSnackBar(context!, respose["error"]);
      }
    } catch (e) {
      changeViewState(AppViewState.idle);

      onError(e, context);
    }

    // (_)=>false
    // (route) => false,
  }

  getAllRightReserverved() async {
    try {
      final response = await CallApi.getRequest(
          "https://step2english.com/stepapis/signleteacher/apis.php?function=property_rights");

      if (response["data"] != null) {
        allRightsText.value = (response['data'].first['text']);
        allRightsCompanyName = (response['data'].first['company']);
        allRightsYear = (response['data'].first['year']);
        allRightsCompanyNameEnglish = (response['data'].first['text2']);
        allRightsLink = (response['data'].first['link']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loginAsGuest(context) {
    SharedPreferencesService.instance.clear();

    SharedPreferencesService.instance
        .setBool(SharedPreferencesKeys.userTypeIsGust, true);

    Navigator.of(context).push(
      routeToPage(HomeMainParentPage()),
      // (route) => false,
    );
  }
}
