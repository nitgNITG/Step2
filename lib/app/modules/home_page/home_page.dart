import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/constants_and_enums/screen_size_constants.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/course_categories/courses_of_category.dart';
import 'package:step/app/modules/course_profile/course_profile_page.dart';
import 'package:step/app/modules/home_page/home_controller.dart';
import 'package:step/app/modules/register/create_account.dart';
import 'package:step/app/utils/routing_utils.dart';
import 'package:step/app/widgets/status_widgets.dart';
import 'package:step/app/widgets/texts.dart';
import 'package:video_player/video_player.dart';
import '../../../main.dart';
import '../../core/data/shared_preferences/helper_funcs.dart';
import '../../core/data/shared_preferences/sharedpreference_service.dart';
import '../../utils/helper_funcs.dart';
import '../global_used_widgets/about_academy_teachers.dart';
import '../login/login_page.dart';
import '../splash/splash_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  final ScrollController scrollController = ScrollController();
  late final VideoPlayerController videoPlayerController;
  late final ChewieController cheweiConrtroller;

  @override
  void initState() {
    controller = getIt.get<HomeController>();

    Future.wait([
      if (!controller.getIsUserGuest()) controller.getEnrollCourses(),
      controller.getAboutAcademy(),
      controller.getAboutAcademyTeachers(),
      controller.getAboutAcademyFreeLessons(),
      controller.getCategories(),

    ]).then((value) {
      setState(() {});
    });

    super.initState();
  }

  Future<void> refreshCallback() async {
    controller.getCategories();
    if (!controller.getIsUserGuest()) controller.getEnrollCourses();
  }

  final titlesFontSize = 18.0;

  @override
  void dispose() {
    // GetIt.I<HomeController>().dispose();
    super.dispose();
  }
  Widget getAppBarLogoAndModesAndNewsBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: getScreenSize(context).height * 0.2 + 15,
          width: getScreenWidth(context),
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              Container(
                height: getScreenSize(context).height * 0.40,
                width: getScreenSize(context).width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/home_appbar.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),                                                                  ///الصوره بتاعه ال appBar
              PositionedDirectional(
                // start: 0,
                top: MediaQuery.paddingOf(context).top + 5,
                child: SizedBox(
                  width: getScreenSize(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const MinistryLogoHorizontalWithName(),
                      Column(
                        children: [
                          getHeightSpace(5),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!controller.getIsUserGuest()) ...{
                                getWidthSpace(8),
                                Builder(builder: (context) {
                                  return SvgPicture.asset(
                                    "assets/images/burger_ic.svg",
                                    height: 15,
                                  ).onTap(
                                        () {
                                      showMenu(
                                        context: context,
                                        position: const RelativeRect.fromLTRB(
                                            0, 20, 0, 0),
                                        items: [
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.logout),
                                                getWidthSpace(5),
                                                getNormalText(
                                                  getL10(context).logout,
                                                  context,
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                            onTap: () async {
                                              await SharedPreferencesService
                                                  .instance
                                                  .clear();

                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                  routeToPage(
                                                      const SplashPage()),
                                                      (route) => false);
                                              // Handle option 2 selection
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                                getWidthSpace(5),
                              },
                              getWidthSpace(10),
                              // const AppThemeModeWidget(),
                              getWidthSpace(15),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),                                                                  ///ال menu بتاع ال appBar
              /// news bar poitioned
            ],
          ),                                                                       /// ال appBar
        ),
        if (controller.getIsUserGuest())
          Positioned(
            bottom: -3,
            width: getScreenWidth(context),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        routeToPage(
                          const LoginPage(),
                        ),
                            (c) => false,
                      );
                      Navigator.of(context).push(
                        routeToPage(
                          const RegisterPage(),
                        ),
                      );
                    },
                    child: getNormalText(
                      getL10(context).joinUs,
                      context,
                      color: kPrimaryColor,
                      weight: FontWeight.bold,
                    ),
                  ),                                                               ///زرار ال join us
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        routeToPage(
                          const LoginPage(),
                        ),
                            (c) => false,
                      );
                    },
                    child: getNormalText(getL10(context).login, context,
                        color: kPrimaryColor, weight: FontWeight.bold),
                  ),                                                              ///زرار ال  Log in
                ],
              ),
            ),
          ),                                                                      ///ال row بتاع الlogin وال signup اللي في ال appBar
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
      injectedObject: controller,
      child: SizedBox(
        height: getScreenSize(context).height,
        width: getScreenSize(context).width,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Positioned(
              top: getScreenHeight(context) * 0.2,
              width: getScreenWidth(context),
              child: SizedBox(
                  height: getScreenSize(context).height -
                      ((getScreenSize(context).height * 0.2)) -
                      (controller.getIsUserGuest()? 0 : ScreenSizeConstants.getBottomNavBarHeight(context)),

                  /// this to listeners is to show error widget when the about academy and categories have error
                  ///
                  child: RefreshIndicator(
                    onRefresh: refreshCallback,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Are you teacher  join us
                          getHeightSpace(25),
                          Visibility(
                            visible: controller.getIsUserGuest(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getNormalText(
                                  "Are you a teacher?",
                                  context,
                                  color: Colors.cyan,
                                  weight: FontWeight.normal,
                                  size: 16,
                                ),
                                getWidthSpace(5),
                                getNormalText(
                                  "Join our team!",
                                  context,
                                  weight: FontWeight.bold,
                                  color: Colors.cyan,
                                  size: 18,
                                ).onTap(() {
                                  contactUsWhatsapp();
                                }),
                              ],
                            ),
                          ),                                                        ///الكلمه بتاعه هل انت مدرس ؟ سجل معنا
                          getHeightSpace(10),

                          /// categories grid list
                          ///

                          ValueListenableBuilder(
                              valueListenable: controller.categoriesState,
                              builder: (context, state, child) {
                                return SizedBox(
                                  height: (controller.categoriesList.length / 3) *
                                      160,
                                  width: getScreenWidth(context),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.categoriesList.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisExtent: 130,
                                    ),
                                    itemBuilder: (context, index,) => SizedBox(
                                      // color: getRandomQuietColor(),
                                      height: 80,
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            controller.categoriesList[index]
                                                .categoryInstance.image,
                                            height: 70,
                                            errorBuilder: (er, obj, st) =>
                                            const Icon(Icons.error),
                                          ),                                           /// صوره المعينات
                                          ElevatedGradientButton(
                                            title: controller
                                                .categoriesList[index]
                                                .categoryInstance
                                                .name,
                                          ),                                           /// اسم الصوره تحتها
                                        ],
                                      ),                                               /// صوره المعين والاسم تحته
                                    ).onTap(
                                          () {
                                        Navigator.of(context).push(
                                          routeToPage(
                                            YearsOfStage(
                                              courseCategory: controller
                                                  .categoriesList[index],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }),                                                       /// ما يخص المعينات

                          ///my class title
                          ///
                          if (!controller.getIsUserGuest() &&
                              controller.myCourses.isNotEmpty) ...{
                            getHeightSpace(20),
                            getTitle(
                                context,
                                getL10(context).myClass.toUpperCase(),
                                getL10(context).myClass.length * 12.0),

                            /// my class list
                            ///
                            getHeightSpace(20),

                            SizedBox(
                              width: getScreenWidth(context),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...controller.myCourses.map((e) => Container(
                                      height: 120,
                                      width: 150,
                                      margin: const EdgeInsets.all(8),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 80,
                                            padding: const EdgeInsets
                                                .symmetric(
                                              vertical: 5,
                                            ),
                                            margin: const EdgeInsets
                                                .symmetric(
                                                vertical: 8,
                                                horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: getThemeData(context)
                                                  .colorScheme
                                                  .background,
                                              boxShadow:
                                              getBoxShadow(context),
                                            ),
                                            child:
                                            Image.network(e.imageUrl),
                                          ),
                                          PositionedDirectional(
                                            bottom: 0,
                                            start: 8,
                                            end: 8,
                                            /// الكلام تحت my class .................................................
                                            child: SizedBox(
                                              height: 40,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xff002E94),
                                                      Color(0xff00FFFF)
                                                    ],
                                                    begin:
                                                    Alignment.topLeft,
                                                    end: Alignment
                                                        .bottomRight,
                                                  ),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .push(
                                                      routeToPage(
                                                        CourseProfilePage(
                                                          myCourse: e,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: getNormalText(
                                                    truncateString(
                                                        e.fullname, 14),
                                                    context,
                                                    color: kOnPrimary,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),).toList(),
                                  ],
                                ),
                              ),
                            ),
                          },

                          ///about academy title
                          ///
                          // ValueListenableBuilder(
                          //     valueListenable: controller.aboutAcademyState,
                          //     builder: (context, state, child) {
                          //       if (state == AppViewState.error) {
                          //         return TryAgainErrorWidget(
                          //             onclickTryAgain: () {
                          //               // controller.getAboutAcademy();
                          //               controller.getCategories();
                          //             });
                          //       } else {
                          //
                          //         return Column(children: [
                          //           if (controller                                    /// المسافه بين ال about academy  والفيديو
                          //               .aboutAcademyTeachers.isNotEmpty) ...{
                          //             getHeightSpace(10),
                          //             getTitle(
                          //               context,
                          //               getL10(context)
                          //                   .aboutAcademy
                          //                   .toUpperCase(),
                          //               getL10(context).aboutAcademy.length *
                          //                   12.0,
                          //             ),
                          //             SizedBox(
                          //                 height: getScreenHeight(context) * 0.3,
                          //                 width: getScreenWidth(context),
                          //                 child: SingleChildScrollView(
                          //                   scrollDirection: Axis.horizontal,
                          //                   child: Row(
                          //                     children: controller.aboutAcademyVideos.map((url) {
                          //                       return Padding(
                          //                         padding: const EdgeInsets.all(8.0),
                          //                         child: SizedBox(
                          //                           width: 290.0, // Adjust the width as needed
                          //                           height: 180.0, // Adjust the height as needed
                          //                           child: AboutAcademyVideo(
                          //                             url: url,
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }).toList(),
                          //                   ),
                          //                 )
                          //             ),                                         /// الفيديو
                          //
                          //           },
                          //
                          //
                          //         ]);
                          //       }
                          //     }),

                          ValueListenableBuilder(
                              valueListenable: controller.aboutAcademyTeachersState,
                              builder: (context, state, child) {
                                if (state == AppViewState.error) {
                                  return TryAgainErrorWidget(
                                      onclickTryAgain: () {
                                        // controller.getAboutAcademy();
                                        controller.getCategories();
                                      });
                                } else {
                                  return Column(children: [
                                    if (controller                                    /// المسافه بين ال about academy  والفيديو
                                        .aboutAcademyTeachers.isNotEmpty) ...{
                                      getHeightSpace(10),
                                      const Text("About Academy",style: TextStyle(color:kPrimaryColor,fontSize: 20,fontWeight: FontWeight.bold)),
                                      Container(
                                        height: 3,
                                        width: 130,
                                        color: const Color(0xff001B58),
                                      ),
                                      SizedBox(
                                          height: getScreenHeight(context) * 0.3,
                                          width: getScreenWidth(context),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: controller.aboutAcademyTeachers.map((url) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                      width: 290.0, // Adjust the width as needed
                                                      height: 180.0, // Adjust the height as needed
                                                      child: YoutubePlayerExample(url: url,context2: context)
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          )

                                      ),                                         /// الفيديو

                                    },
                                  ]);
                                }
                              }),
                          ValueListenableBuilder(
                              valueListenable: controller.aboutAcademyFreeLessonsState,
                              builder: (context, state, child) {
                                if (state == AppViewState.error) {
                                  return TryAgainErrorWidget(
                                      onclickTryAgain: () {
                                        // controller.getAboutAcademy();
                                        controller.getCategories();
                                      });
                                } else {
                                  return Column(children: [
                                    if (controller                                    /// المسافه بين ال about academy  والفيديو
                                        .aboutAcademyFreeLessons.isNotEmpty) ...{
                                      getHeightSpace(10),
                                      Text("Free Recorded Lessons",style: TextStyle(color:kPrimaryColor,fontSize: 20,fontWeight: FontWeight.bold)),
                                      Container(
                                        height: 3,
                                        width: 225,
                                        color: Color(0xff001B58),
                                      ),
                                      SizedBox(
                                          height: getScreenHeight(context) * 0.3,
                                          width: getScreenWidth(context),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: controller.aboutAcademyFreeLessons.map<Widget>((url) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:   YoutubePlayerExample(url: url,context2: context)
                                                );
                                              }).toList(),
                                            ),
                                          )

                                      ),                                         /// الفيديو

                                    },
                                  ]);
                                }
                              }),


                          //if (controller.aboutAcademyDescription.isNotEmpty) ...{
                          //getHeightSpace(20),
                          //Padding(
                          //padding: const EdgeInsets.all(5),
                          //child: Text(
                          //'kids’ Gallery',style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          //fontSize: 20,
                          //color: Color(0xff003999)),),
                          //),                                                     /// كلمه kid's gallery
                          ///الخط اللي تحت ال Kid's Gallery
                          /// صور الاطفال في الميتنج
                          //},
                          if (controller.aboutAcademyDescription.isNotEmpty) ...{                             /// bout Us
                            getHeightSpace(20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20,right: 10,left: 10),
                              child: HtmlWidget(
                                controller.aboutAcademyDescription,
                                renderMode: const ColumnMode(),
                                textStyle: TextStyle(
                                  color: getThemeData(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            )
                          }         /// المسافه بين الفيديو والdescription
                        ],
                      ),
                    ),
                  )),
            ),
            getAppBarLogoAndModesAndNewsBar(context),
          ],
        ),
      ),
    );
  }

  // About Academy
  Row getTitle(BuildContext context, String title, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getWidthSpace(10),

        // about academy
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: getThemeData(context).colorScheme.onBackground,
                height: 1.8,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decorationColor:kPrimaryColor,
              ),
            ), // about academy
            Container(
              color: Color(0xff001B52),
              height: 3,
              width: width,
            ),                                                                    ///الخط اللي تحت ال about academy
          ],
        ),
      ],
    );
  }
}