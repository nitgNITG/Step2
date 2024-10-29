import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/data/models/course.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/course_profile/course_profile_controller.dart';
import 'package:step/app/modules/course_profile/items/course_drawer.dart';
import 'package:step/app/modules/global_used_widgets/widget_methods.dart';
import 'package:step/app/widgets/status_widgets.dart';
import 'package:step/app/widgets/texts.dart';

import '../../core/data/models/my_course.dart';
import '../../core/data/shared_preferences/helper_funcs.dart';
import '../../utils/helper_funcs.dart';
import '../../widgets/app_bars.dart';
import '../home/main_app_controller.dart';

class CourseProfilePage extends StatefulWidget {
  const CourseProfilePage({super.key, this.myCourse, this.course});

  final MyCourse? myCourse;
  final Course? course;

  @override
  State<CourseProfilePage> createState() => _CourseProfilePageState();
}

class _CourseProfilePageState extends State<CourseProfilePage>
    with TickerProviderStateMixin {
  late final CourseProfileController controller;
  final MainAppController controller1 = MainAppController();


  @override
  void initState() {
    controller = CourseProfileController();
    controller.getCourseDetails(getCourseId());

    controller.isEnrolledToCourse.addListener(() {
      if (!controller.isEnrolledToCourse.value) {
        showMyDialog();
      }
    });
    controller1.getWhatsAppPhone();
    super.initState();
  }

  showMyDialog() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 1.5,
        ),
        child: AlertDialog(
          backgroundColor: getThemeData(context).colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              getNormalText(
                getL10(context).notes,
                context,
                color: getThemeData(context).colorScheme.onBackground,
                weight: FontWeight.bold,
                size: 22,
              ),
              const Spacer(),
              Container(
                child: SvgPicture.asset(
                  "assets/images/close_ic.svg",
                ).onTap(() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
              )
            ],
          ),
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          actionsAlignment: MainAxisAlignment.start,
          content: SizedBox(
            height: getScreenHeight(context) * 0.15,
            child: Column(
              children: [
                getNormalText(
                  "You are not enrolled in this course Call us in Whatsapp to enroll",
                  context,
                  // color: kOnPrimary,
                ),
                const Spacer(),
                Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        height: getScreenHeight(context) * 0.05,
                        child:
                            SvgPicture.asset("assets/images/whatsapp_ic.svg"),
                      ),
                    ).onTap(() {                                                         /// فانكشن الواتساب
                      contactUsWhatsapp(controller1.phone);
                    }),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.15),
    );
  }

  String getCourseId() {
    return widget.course == null ? widget.myCourse!.id : widget.course!.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ValueListenableBuilder(
          valueListenable: controller.state,
          builder: (context, state, widget) {
            if (state == AppViewState.idle &&
                controller.isUserTeacherOfThisCourseOrAdmin()) {
              return CourseDrawer(controller,
                  title: getTitle(),
                  subtitle: getSubTitle(),
                  image: getImage());
            }
            return const SizedBox();
          }),
      body: Stack(
        children: [
          getAppPostionedBackground(context),
          Column(
            children: [
              StreamBuilder<ConnectivityResult>(
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, snapshot) {
                    if (snapshot.data != ConnectivityResult.none) {
                      return NormalAppBar(
                        title: getTitle(),
                        subTitle: getSubTitle(),
                        trailing: ValueListenableBuilder(
                          valueListenable: controller.state,
                          builder: (context, state, child) {
                            if (state == AppViewState.idle &&
                                controller.isUserTeacherOfThisCourseOrAdmin()) {
                              return const Icon(
                                Icons.menu,
                                color: kOnPrimary,
                                size: 30,
                              ).onTap(() {
                                Scaffold.of(context).openDrawer();
                              });
                            }
                            return const SizedBox();
                          },
                        ),
                      );
                    }
                    return Container();
                  }),
              Expanded(
                child: BaseView<CourseProfileController>(
                  injectedObject: controller,
                  child: ValueListenableBuilder<AppViewState>(
                    valueListenable: controller.state,
                    builder: (context, state, widget) =>
                        getWidgetDependsInAppViewState(state, onClick: () {
                      controller.getCourseDetails(getCourseId());
                    },
                            PageView.builder(
                              controller: controller.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.getPages(context).length,
                              itemBuilder: (context, index) => controller
                                  .getPages(context)
                                  .elementAt(index)['widget'],
                            )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getSubTitle() {
    if (widget.course != null) {
      return widget.course!.fullName;
    }
    return widget.myCourse!.fullname;
  }

  String getImage() {
    if (widget.course != null) {
      return widget.course!.imageUrl;
    }
    return widget.myCourse!.imageUrl;
  }

  String getTitle() {
    if (widget.course != null) {
      return widget.course!.shortName;
    }
    return widget.myCourse!.shortname;
  }
}
