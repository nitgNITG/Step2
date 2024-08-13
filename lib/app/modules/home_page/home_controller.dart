import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/data/api/ApiCall.dart';
import 'package:step/app/modules/base/base_controller.dart';

import '../../core/constants_and_enums/static_data.dart';
import '../../core/data/models/category.dart';
import '../../core/data/models/my_course.dart';

class HomeController extends BaseController {
  List<AcademicStage> categoriesList = [];

  // List<MyCourse> myCoursesList = [];
  List<String> aboutAcademyVideos = [];
  List<String> aboutAcademyTeachers = [];
  List<String> aboutAcademyFreeLessons = [];
  List<MyCourse> myCourses = [];

  var aboutAcademyState = ValueNotifier(AppViewState.busy);
  var aboutAcademyTeachersState = ValueNotifier(AppViewState.busy);
  var aboutAcademyFreeLessonsState = ValueNotifier(AppViewState.busy);
  var categoriesState = ValueNotifier(AppViewState.busy);

  String aboutAcademyDescription = "";

  Future<void> getCategories() async {
    try {
      categoriesState.value = AppViewState.busy;
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=getCategoriesWithSubcategories",
      );

      if (response['status'] != 'fail') {
        categoriesList = (response['data'] as List)
            .map((e) {
          return AcademicStage.fromJson(e);
        })
            .cast<AcademicStage>()
            .toList();
        changeViewState(AppViewState.idle);
        categoriesState.value = AppViewState.idle;
      }

    } catch (e) {
      debugPrint(e.toString());
      changeViewState(AppViewState.error);
      categoriesState.value = AppViewState.error;
    }
  }

  Future<void> getEnrollCourses() async {
    try {
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=get_enrol_courses&token=${getLoggedUser().token}",
      );
      if (response['status'] != 'fail') {
        myCourses = (response['courses'] as List)
            .map((e) {
          return MyCourse.fromJson(e);
        })
            .cast<MyCourse>()
            .toList();

        changeViewState(AppViewState.idle);
      }
    } catch (e) {
      debugPrint(e.toString());
      changeViewState(AppViewState.error);
    }
  }

  Future<void> getAboutAcademy() async {
    try {
      aboutAcademyState.value = AppViewState.busy;
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=aboutInfo",
      );

      aboutAcademyVideos = (response['videos'] as List)
          .map((e) {
        return e['filename'];
      })
          .cast<String>()
          .toList();

      aboutAcademyDescription = response['about_1_block']['text'];
      changeViewState(AppViewState.idle);
      aboutAcademyState.value = AppViewState.idle;
    } catch (e) {
      // showSnackBar(context!, e.toString());
      debugPrint(e.toString());
      changeViewState(AppViewState.error);
      aboutAcademyState.value = AppViewState.error;

    }
  }

  Future<void> getAboutAcademyTeachers() async {
    try {
      aboutAcademyTeachersState.value = AppViewState.busy;
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=our_teachers",
      );

      aboutAcademyTeachers = (response['data'] as List)
          .map((e) {
        return e['filename'];
      })
          .cast<String>()
          .toList();


      changeViewState(AppViewState.idle);
      aboutAcademyTeachersState.value = AppViewState.idle;
    } catch (e) {
      // showSnackBar(context!, e.toString());
      debugPrint(e.toString());
      changeViewState(AppViewState.error);
      aboutAcademyTeachersState.value = AppViewState.error;

    }
  }

  Future<void> getAboutAcademyFreeLessons() async {
    try {
      aboutAcademyFreeLessonsState.value = AppViewState.busy;
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=our_teachers2",
      );

      aboutAcademyFreeLessons = (response['data'] as List)
          .map((e) {
        return e['filename'];
      })
          .cast<String>()
          .toList();


      changeViewState(AppViewState.idle);
      aboutAcademyFreeLessonsState.value = AppViewState.idle;
    } catch (e) {
      // showSnackBar(context!, e.toString());
      debugPrint(e.toString());
      changeViewState(AppViewState.error);
      aboutAcademyFreeLessonsState.value = AppViewState.error;

    }
  }

}
