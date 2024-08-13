import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/data/models/course_details.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/modules/base/base_controller.dart';
import 'package:step/app/modules/web_view/view/web_view.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/widgets/messages.dart';

import '../../core/data/api/ApiCall.dart';
import 'course_pages/couse_members.dart';
import 'course_pages/vourse_info_details.dart';

class CourseProfileController extends BaseController {
  late CourseDetails courseDetails;

  final pageController = PageController();

  ValueNotifier<bool> isEnrolledToCourse = ValueNotifier(true);

  Map<String, dynamic> getEnrollToCourseButton(context, String courseId) {
    /// if he is guest the button will not appear
    if (getIsUserGuest()) {
      return Map.of(
        {
          "buttonTitle": "login or regiter to Enroll to course",
          "function": () {
            showSnackBar(
              context,
              "login or regiter to Enroll to course",
            );
          },
          "display": false
        },
      );
    }

    /// if he is student the button will appear
    /// if the course is free it will be enroll to course if not free it will be add to couse

    if (getLoggedUser().role == "student") {
      bool display = false;

      final EnrollStudent? enrollStudent =
          courseDetails.enrolUsers.firstWhereOrNull(
        (element) => element.id == getLoggedUser().id.toString(),
      );

      /// if null this mean he is not enrolled and should enroll
      display = (enrollStudent == null);
      return Map.of(
        {
          "display": display,
          "buttonTitle": getL10(context).enrollToCourse,
          "function": () {
            enrollToCourse(context, courseId);
          },
        },
      );
    } else {
      /// this mean he is teacher or admin
      return Map.of({"display": false, "name": "email"});
    }
  }

  setIsStudentEnrolledToCourse() {
    /// if he is student check if he is enrolled
    if (getLoggedUser().role == "student") {
      final EnrollStudent? enrollStudent =
          courseDetails.enrolUsers.firstWhereOrNull(
        (element) => element.id == getLoggedUser().id.toString(),
      );
      isEnrolledToCourse.value = enrollStudent != null;
    } else {
      /// this mean he is teacher
      isEnrolledToCourse.value = true;
    }
  }

  setPage(int i) {
    pageController.jumpToPage(i);
  }

  List<Map<String, dynamic>> getPages(context) {
    if (state.value == AppViewState.idle) {
      if (!getIsUserGuest()) {
        return [
          Map.of({
            "name": getL10(context).courseContent,
            "index": 0,
            "widget": const CourseInfoWidget(),
            "icon": "assets/images/my_class.svg"
          }),
          Map.of({
            "name": getL10(context).enrolledStudents,
            "index": 1,
            "icon": "assets/images/participants_ic.svg",
            "widget": CourseMembersWidget(courseDetails.courseId),
          }),
          Map.of({
            "name": getL10(context).reports,
            "index": 2,
            "icon": "assets/images/reports_ic.svg",
            "widget": AppWebView(
              "https://step2english.com/report/view.php?courseid=${courseDetails.courseId}&token=${getLoggedUser().token}",
              getL10(context).reports,
              showAppBar: false,
            ),
          }),
          Map.of({
            "name": getL10(context).grades,
            "index": 3,
            "icon": "assets/images/grades_ic.svg",
            "widget": AppWebView(
              "https://step2english.com/grade/report/grader/index.php?id=${courseDetails.courseId}&token=${getLoggedUser().token}",
              getL10(context).reports,
              showAppBar: false,
            ),
          }),
          Map.of({
            "name": getL10(context).settings,
            "index": 4,
            "icon": "assets/images/settings.svg",
            "widget": AppWebView(
              "https://step2english.com/course/edit.php?id=${courseDetails.courseId}&token=${getLoggedUser().token}",
              getL10(context).reports,
              showAppBar: false,
            ),
          }),
        ];
      }
      return [
        Map.of({
          "name": getL10(context).courseContent,
          "index": 0,
          "widget": const CourseInfoWidget(),
        }),
      ];
    }
    return [];
  }

  getCourseDetails(String courseId) async {
    try {
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
          "${StaticData.baseUrl}/academyApi/json.php?function=course_content_mobile&courseID=$courseId");
      if (response['data'] != null) {
        courseDetails = CourseDetails.fromJson(response['data']);
        changeViewState(AppViewState.idle);

        setIsStudentEnrolledToCourse();
      }
    } catch (e) {
      showSnackBar(context!, e.toString());
      debugPrint(e.toString());

      changeViewState(AppViewState.error);
    }
  }

/*
  bool checkisOneOfTheCourseTeachers() =>
      courseDetails.teachers.firstWhereOrNull((element) =>
          element.teacherId.toString() == getLoggedUser().id.toString()) !=
      null; */

  bool isUserTeacherOfThisCourseOrAdmin() {
    /// if user not quest and one of course teachers or admin
    return ((!getIsUserGuest()) &&
        getLoggedUser().role != "student" &&
        (getLoggedUser().role == "admin" || getLoggedUser().role == "teacher"));
    // &&
    // (checkisOneOfTheCourseTeachers() != null);
  }

  bool isUserTeacherOfThisCourseOrAdminOrStudentSubscribed() {
    bool isSubscribed = false;
    try {
      final isEnrolledToCourse = courseDetails.enrolUsers.firstWhereOrNull(
            (element) => element.id == getLoggedUser().id.toString(),
          ) !=
          null;

      isSubscribed = isUserTeacherOfThisCourseOrAdmin() || isEnrolledToCourse;
    } catch (e) {
      isSubscribed = false;
    } finally {
      return isSubscribed;
    }
  }

  void enrollToCourse(context, String courseId) async {
    try {
      changeViewState(AppViewState.busy);
      final response = await CallApi.getRequest(
          "https://manpoweracademy.nitg-eg.com/mohamedmekhemar/academyApi/json.php?function=enrol_student&token=${getLoggedUser().token}&courseID=${courseDetails.courseId}");
      if (response['status'] == "success") {
        showSnackBar(context, getL10(context).enrolled, color: Colors.green);
        changeViewState(AppViewState.idle);
        getCourseDetails(courseId.toString());
      }
    } catch (e) {
      changeViewState(AppViewState.error);
      showSnackBar(context, e.toString());
    }
  }

  void addToCart(context, String courseId) async {
    debugPrint("add to cart /////");

    {
      try {
        changeViewState(AppViewState.busy);
        final response = await CallApi.getRequest(
            "https://manpoweracademy.nitg-eg.com/mohamedmekhemar/academyApi/json.php?function=add_to_cart&token=${getLoggedUser().token}&courseID=${courseDetails.courseId}");
        if (response['status'] == "success") {
          showSnackBar(context, getL10(context).addedSuccessful,
              color: Colors.green);
          changeViewState(AppViewState.idle);
          // await getCourseDetails(courseId.toString());

          await Future.delayed(Duration(seconds: 2));
        }
      } catch (e) {
        debugPrint("////exception from add to cart");
        debugPrint(e.toString());
        changeViewState(AppViewState.error);
        showSnackBar(context, e.toString());
      }
    }
  }
}
