import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/course_profile/course_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/data/models/logged_user.dart';
import '../../../core/data/shared_preferences/shared_preferences_keys.dart';
import '../../../core/data/shared_preferences/sharedpreference_service.dart';
import '../../../utils/helper_funcs.dart';

class CourseDrawer extends StatefulWidget {
  const CourseDrawer(
    this.controller, {
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });
  final CourseProfileController controller;
  final String title, subtitle, image;

  @override
  State<CourseDrawer> createState() => _CourseDrawerState();
}

class _CourseDrawerState extends State<CourseDrawer> {
  LoggedUser? loggedUser;
  late final isUserGuest;
  @override
  void initState() {
    String? jonString = SharedPreferencesService.instance
        .getString(SharedPreferencesKeys.loggedUser);
    if (jonString != null) loggedUser = LoggedUser.fromString(jonString);

    isUserGuest = widget.controller.getIsUserGuest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: getScreenSize(context).width * 0.7,
      backgroundColor: getThemeData(context).colorScheme.background,
      child: SizedBox(
        // color: Colors.deepOrangeAccent,
        width: getScreenSize(context).width * 0.7,
        height:
            getScreenSize(context).height - MediaQuery.paddingOf(context).top,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SvgPicture.asset(
                "assets/images/app_bg.svg",
                height: getScreenSize(context).height -
                    MediaQuery.paddingOf(context).top,
                width: getScreenSize(context).width * 0.7,
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    getThemeData(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.08),
                    BlendMode.srcIn),
              ),
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: getScreenSize(context).height * 0.05),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.image,
                            height: getScreenSize(context).height * 0.25,
                            width: getScreenSize(context).width * 0.7,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    if (!isUserGuest)
                      PositionedDirectional(
                        top: getTopPadding(context),
                        start: 0,
                        child: Row(
                          children: [
                            Image.network(loggedUser!.image, width: 30),
                            getWidthSpace(10),
                            Text(loggedUser!.firstName),
                          ],
                        ),
                      ),
                    Positioned(
                      width: getScreenSize(context).width * 0.7,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            // height: 50,
                            // width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color:
                                  getThemeData(context).colorScheme.background,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: getThemeData(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        height: 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  widget.subtitle,
                                  style: getThemeData(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          // height: 0.9,
                                          ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                ...widget.controller
                    .getPages(context)
                    .map((e) => buildCourseDrawerItem(
                          context,
                          e['index'],
                          e['name'],
                          e['icon'],
                        ))
                    .toList(),

                const Spacer(),
                const Spacer(),

                /// this is the login button of Guest
                if (isUserGuest)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          icon: Icon(
                            Icons.logout,
                            color:
                                getThemeData(context).colorScheme.onBackground,
                            weight: 20,
                          ),
                          label: Text(
                            getL10(context).login,
                            style: getThemeData(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold
                                    // height: 0.9,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildCourseDrawerItem(
      BuildContext context, int index, String title, String icon) {
    final bool isSelected = widget.controller.pageController.page == index;
    return SizedBox(
      width: getScreenWidth(context) * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Colors.cyan.withOpacity(0.7) : Colors.cyan),
        onPressed: () async {
          setState(() {
            widget.controller.setPage(index);
          });

          await Future.delayed(const Duration(
            milliseconds: 400,
          ));
          Navigator.of(context).pop();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          getWidthSpace(10),
          SvgPicture.asset(
            icon,
            height: 30,
            colorFilter: ColorFilter.mode(
              isSelected ? kSecondaryColor : kOnPrimary,
              BlendMode.srcIn,
            ),
          ),
          getWidthSpace(10),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? kSecondaryColor : kOnPrimary,
            ),
          ),
          getWidthSpace(10)
        ]),
      ),
    );
  }
}
