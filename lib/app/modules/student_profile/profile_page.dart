import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/data/models/logged_user.dart';
import 'package:step/app/core/data/shared_preferences/shared_preferences_keys.dart';
import 'package:step/app/core/data/shared_preferences/sharedpreference_service.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/course_profile/course_profile_page.dart';
import 'package:step/app/modules/home_page/helper_widgets/course_item.dart';
import 'package:step/app/modules/student_profile/profile_controller.dart';
import 'package:step/app/modules/student_profile/sub_widgets/edit_profile_bottom_sheet.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/utils/routing_utils.dart';
import 'package:step/app/widgets/app_bars.dart';
import 'package:step/app/widgets/image_picker.dart';
import 'package:step/app/widgets/texts.dart';

import '../global_used_widgets/widget_methods.dart';
import '../login/login_page.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late final ProfileController controller;

  LoggedUser getLoggedUser() {
    final jsonString = SharedPreferencesService.instance.getString(SharedPreferencesKeys.loggedUser);
    return LoggedUser.fromString(jsonString!);
  }

  @override
  void initState() {
    controller = ProfileController();
    controller.getAllCourses().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenSize(context).height - (MediaQuery.of(context).padding.bottom),
      width: getScreenSize(context).width,
      child: BaseView<ProfileController>(
        injectedObject: controller,
        child: Scaffold(
          body: Container(
            height: getScreenSize(context).height - (MediaQuery.of(context).padding.bottom),
            width: getScreenSize(context).width,
            color: getThemeData(context).colorScheme.background,
            child: Builder(builder: (context) {
              final loggedUser = controller.getLoggedUser();
              return Stack(
                children: [
                  getAppPostionedBackground(context),
                  SizedBox(
                    height: getScreenSize(context).height - (MediaQuery.of(context).padding.bottom),
                    width: getScreenWidth(context),
                    child: Column(
                      children: [
                        NormalAppBar(
                          title: getL10(context).profile,
                          icon: "assets/images/profile_bottom_bar_ic.svg",
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getHeightSpace(10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        getWidthSpace(10),
                                        ImagePickerWidget(
                                          loggedUser: loggedUser,
                                        ),
                                        getWidthSpace(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            getNormalText(
                                              "${loggedUser.firstName} ${loggedUser.lastName}",
                                              context,
                                              weight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: getNormalText(
                                                loggedUser.email,
                                                context,
                                                weight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Builder(builder: (context) {
                                          return const Icon(
                                            Icons.edit_calendar_sharp,
                                          ).onTap(() {
                                            controller.setDataForBottomSheet();
                                            Navigator.of(context).push(
                                              routeToPage(
                                                EditProfileBottomSheet(
                                                  controller: controller,
                                                ),
                                              ),
                                            );
                                          });
                                        }),
                                        getWidthSpace(10)
                                      ],
                                    ),
                                    getHeightSpace((getScreenSize(context).height * 0.03)),
                                    getWidthSpace(10),
                                    Center(
                                      child: getTitleText(
                                        getL10(context).personalData,
                                        context,
                                        color: getThemeData(context).colorScheme.onBackground,
                                      ),
                                    ),
                                    getHeightSpace(10),
                                    getRowItemProfile(
                                      context,
                                      getL10(context).name,
                                      "${loggedUser.firstName} ${loggedUser.lastName}",
                                    ),
                                    SizedBox(
                                      width: 340,
                                      child: getRowItemProfile(
                                        context,
                                        getL10(context).email,
                                        loggedUser.email,
                                      ),
                                    ),
                                    getRowItemProfile(
                                      context,
                                      getL10(context).phone,
                                      loggedUser.phone,
                                    ),
                                    getRowItemProfile(
                                      context,
                                      getL10(context).numberOfEnrolledCourses,
                                      loggedUser.coursesCount.toString(),
                                    ),
                                    getHeightSpace(20),
                                    Center(
                                      child: getTitleText(
                                        getL10(context).myClass,
                                        context,
                                        weight: FontWeight.bold,
                                        color: getThemeData(context).colorScheme.onBackground,
                                      ),
                                    ),
                                    getHeightSpace(10),
                                    SizedBox(
                                      height: 200,
                                      width: getScreenSize(context).width,
                                      child: Builder(builder: (context) {
                                        if (controller.myCoursesList.isNotEmpty) {
                                          return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: controller.myCoursesList.length,
                                            itemBuilder: (context, index) => CourseItemMyCourse(
                                              myCourse: controller.myCoursesList[index],
                                            ).onTap(() {
                                              Navigator.of(context).push(
                                                routeToPage(
                                                  CourseProfilePage(
                                                    myCourse: controller.myCoursesList[index],
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        } else {
                                          return getNormalText(
                                            "You are not enrolled in any courses yet!",
                                            context,
                                          );
                                        }
                                      }),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xff002E94), Color(0xff00FFFF)],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () async {
                                          await _showConfirmationDialog(context);
                                        },
                                        child: Text('Delete User', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User', style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.w500)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteUserAccount(context);
                Navigator.of(context).pushAndRemoveUntil(
                  routeToPage(
                    const LoginPage(),
                  ),
                      (c) => false,
                );
              },
              child: Text('Yes', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUserAccount(BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse("${StaticData.baseUrl}/academyApi/json.php?function=delete_user_account&token=${getLoggedUser().token}"));

      if (response.statusCode == 200) {
        print('Account Deleted Successfully');
      } else {
        print('Error deleting account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }
  Widget getRowItemProfile(BuildContext context, title, value) {
    return Column(
      children: [
        getHeightSpace(10),
        getNormalText(title + " : " + value, context, weight: FontWeight.bold),
      ],
    );
  }
}