import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:step/app/core/data/shared_preferences/helper_funcs.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/modules/base/base_view.dart';
import 'package:step/app/modules/global_used_widgets/app_bottom_navigation.dart';
import 'package:step/app/modules/global_used_widgets/widget_methods.dart';
import 'package:step/app/modules/home/main_app_controller.dart';
import 'package:step/app/utils/helper_funcs.dart';

import '../../widgets/texts.dart';

class HomeMainParentPage extends StatelessWidget {
  HomeMainParentPage({super.key, this.connectivityResult});

  final MainAppController controller = MainAppController();
  final ConnectivityResult? connectivityResult;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (popInvoked) {
        // debugPrint("invodes");
        showDialog(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2.0,
              sigmaY: 1.5,
            ),
            child: AlertDialog(
              backgroundColor: getThemeData(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                height: getScreenHeight(context) * 0.18,
                child: Column(
                  children: [
                    getNormalText(
                      getL10(context).areYouSureYouWantToExit,
                      context,
                      // color: kOnPrimary,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff002E94),
                                    Color(0xff00FFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton(
                            onPressed: () {
                              exit(0);
                            },
                            child: Text(
                              getL10(context).yes,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff002E94),
                                    Color(0xff00FFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              getL10(context).cancel,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),                                                   /// اخر حاجه خالص هل تريد الخروج ام لا
          ),
          barrierDismissible: true,
          barrierColor:
              const Color.fromARGB(255, 255, 255, 255).withOpacity(0.15),
        );
      },
      canPop: false,
      child: BaseView<MainAppController>(
        injectedObject: controller,
        connectivityResult: connectivityResult,
        child: Container(
          color: getThemeData(context).colorScheme.background,
          child: Stack(
            children: [
              getAppPostionedBackground(context),
              Scaffold(
                backgroundColor: Colors.white.withOpacity(0),
                floatingActionButton: ValueListenableBuilder(
                  valueListenable: controller.currentPageIndex,
                  builder: (context, index, ch) {
                    if (index == 0) {
                      return SvgPicture.asset("assets/images/whatsapp_ic.svg")
                          .onTap(
                        () {
                          contactUsWhatsapp();
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                body: PageView.builder(
                  controller: controller.pageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.getIsUserGuest()
                      ? controller.pagesForPageViewForGuest.length
                      : controller.pagesForPageView.length,
                  itemBuilder: (context, index) => controller.getIsUserGuest()
                      ? controller.pagesForPageViewForGuest[index]
                      : controller.pagesForPageView[index],
                ),
                bottomNavigationBar: !controller.getIsUserGuest()
                    ? const AppBottomNavigationBar()
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
