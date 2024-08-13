import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/course_profile/course_profile_page.dart';
import 'package:step/app/modules/my_class/my_courses_controller.dart';
import 'package:step/app/modules/search_courses_eachers/search_page.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/utils/routing_utils.dart';
import 'package:step/app/widgets/app_bars.dart';
import 'package:step/app/widgets/texts.dart';

import '../../../main.dart';
import '../../core/data/models/course.dart';
import '../../core/data/models/my_course.dart';
import '../../core/global_used_widgets/general_use.dart';
import '../home_page/home_controller.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  late final MyCoursesController controller;

  getPageHeight(BuildContext context) {
    return getScreenSize(context).height - getTopPadding(context);
  }

  @override
  void initState() {
    controller = MyCoursesController();
    runGetCourses();
    super.initState();
  }

  runGetCourses() {
    controller.getEnrollCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: BaseView<MyCoursesController>(
        injectedObject: controller,
        child: SizedBox(
          height: getPageHeight(context),
          width: getScreenSize(context).width,
          child: Column(
            children: [
              NormalAppBar(
                title: getL10(context).myClass,
                icon: "assets/images/my_class.svg",

              ),
              ValueListenableBuilder(
                valueListenable: controller.state,
                builder:
                    (BuildContext context, AppViewState value, Widget? child) {
                  return Expanded(
                    child: GridView.builder(
                      itemCount: controller.myCourses.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisExtent: 160

                        // childAspectRatio: 15 / 11
                        // mainAxisSpacing: 8.0,
                        // mainAxisExtent: 1.0,
                      ),
                      itemBuilder: (context, index) => Container(
                        height: 200,
                        width: 150,
                        // color: getRandomQuietColor(),
                        margin: const EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: getThemeData(context)
                                    .colorScheme
                                    .background,
                                boxShadow: getBoxShadow(context),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      controller.myCourses[index].imageUrl,
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 8,
                              child: Container(
                                height: 40,
                                width: 152,
                                alignment: Alignment.bottomCenter,
                                child: SizedBox.expand(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff002E94),
                                          Color(0xff00FFFF)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: null,
                                      child: getNormalText(
                                        truncateString(
                                            controller.myCourses[index].fullname,
                                            16),
                                        context,
                                        color: kOnPrimary,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        if (getIt<HomeController>().getIsUserGuest()) {
                          displayYouNeedLogin(context);
                        } else {
                          Navigator.of(context).push(
                            routeToPage(
                              CourseProfilePage(
                                myCourse: controller.myCourses[index],
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  getCourse(int index) {
    return controller.myCourses[index];
  }
}

class CourseOrMyCourseItemFromCoursesPage extends StatelessWidget {
  const CourseOrMyCourseItemFromCoursesPage(
      this.controller, {
        super.key,
        this.course,
        this.myCourse,
      });

  final MyCoursesController controller;
  final Course? course;
  final MyCourse? myCourse;

  String getImageUrl() {
    if (course != null) {
      return course!.imageUrl;
    } else {
      return myCourse!.overviewfiles.firstOrNull == null
          ? ""
          : "${myCourse!.overviewfiles.first.fileurl}?token=${controller.getLoggedUser().token!}";
    }
  }

  String getCourseTitle() {
    if (course != null) {
      return course!.fullName;
    }
    return myCourse!.fullname;
  }

  String getCourseSubTitle() {
    if (course != null) {
      return course!.description!;
    }
    return myCourse!.summary;
  }

  getIsCourse() => course == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(
            getImageUrl(),
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getCourseTitle(),
            style: getThemeData(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: kOnPrimary,
                fontSize: 18,
                height: 1.4,
                backgroundColor: kSecondaryColor.withOpacity(0.3),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ]),
            textAlign: TextAlign.start,
          ),
          Builder(builder: (context) {
            final summery = getCourseSubTitle();
            return Text(
              summery.substring(0, summery.length > 40 ? 40 : summery.length),
              style: getThemeData(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kOnPrimary,
                  fontSize: 18,
                  height: 1.4,
                  backgroundColor: kSecondaryColor.withOpacity(0.3),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 3.0,
                    ),
                  ]),
              textAlign: TextAlign.start,
            );
          }),
          ElevatedButton(onPressed: () {}, child: const Text("المزيد")),
          const Spacer(),

          /// progress visible if not guest
          if (getIsCourse())
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: getScreenSize(context).width * 0.72,
                  child: LinearProgressIndicator(
                    value: (myCourse!.progress / 100),
                    minHeight: 12,
                    color: kSecondaryColor,
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                getWidthSpace(10),
                Container(
                  color: kSecondaryColor.withOpacity(0.3),
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    ("${myCourse!.progress.floorToDouble()}%"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
