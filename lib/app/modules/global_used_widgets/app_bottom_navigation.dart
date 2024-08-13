import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/home/main_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../global_providers/localization_provider.dart';
import '../../core/constants_and_enums/screen_size_constants.dart';
import '../../utils/helper_funcs.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  late final MainAppController controller;

  @override
  void initState() {
    controller = Provider.of<MainAppController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.currentPageIndex,
      builder: (context, pageIndex, child) {
        Provider.of<LocalizationProvider>(context, listen: true);
        return AnimatedContainer(
          // padding: EdgeInsets.symmetric(vertical: 5),
          height: ScreenSizeConstants.getBottomNavBarHeight(context),
          duration: const Duration(milliseconds: 500),
          // color: Colors.amber,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff002E94),
                Color(0xff00FFFF)
              ],
              begin:Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: getScreenSize(context).width,

          ///  here check if the user is guest to not show the bottom navigationBar
          child: Row(
            mainAxisAlignment: controller.getIsUserGuest()
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.getIsUserGuest())
                ...controller
                    .bottomBarListForGuest()
                    .map((e) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: pageIndex == e["index"]
                            ? kOnPrimary.withOpacity(0.8)
                            : null,
                        padding: pageIndex == e["index"]
                            ? const EdgeInsets.symmetric(
                          horizontal: 10,
                        )
                            : const EdgeInsets.symmetric(horizontal: 0),
                        height:
                        ScreenSizeConstants.getBottomNavBarHeight(
                            context) *
                            0.6,
                        child: SvgPicture.asset(
                          e["icon"].toString(),
                          colorFilter: ColorFilter.mode(
                            pageIndex == e["index"]
                                ? kPrimaryColor
                                : kOnPrimary,
                            BlendMode.srcIn,
                          ),
                          /* height:
                                      ScreenSizeConstants.getBottomNavBarHeight(
                                              context) *
                                          0.6,*/
                        ),
                      ),
                      const Spacer(),
                      Text(
                        e["name"].toString(),
                        style: const TextStyle(
                          height: 0.9,
                          // color: pageIndex == e["index"]?kSecondaryColor:null
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ).onTap(() {
                  controller.setPage(e["index"]);
                }))
                    .toList()
              else
                ...controller
                    .bottomBarList()
                    .map((e) => AnimatedContainer(
                  // color: getRandomQuietColor(),
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: pageIndex == e["index"]
                            ? kOnPrimary.withOpacity(0.8)
                            : null,
                        padding: pageIndex == e["index"]
                            ? const EdgeInsets.symmetric(
                          horizontal: 10,
                        )
                            : const EdgeInsets.symmetric(horizontal: 0),
                        height:
                        ScreenSizeConstants.getBottomNavBarHeight(
                            context) *
                            0.6,
                        child: SvgPicture.asset(
                          e["icon"].toString(),
                          colorFilter: ColorFilter.mode(
                            pageIndex == e["index"]
                                ? kPrimaryColor
                                : kOnPrimary,
                            BlendMode.srcIn,
                          ),
                          /* height:
                                      ScreenSizeConstants.getBottomNavBarHeight(
                                              context) *
                                          0.6,*/
                        ),
                      ),
                      const Spacer(),
                      Text(
                        e["name"].toString(),
                        style: const TextStyle(
                          height: 0.9,
                          // color: pageIndex == e["index"]?kSecondaryColor:null
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ).onTap(() {
                  controller.setPage(e["index"]);
                }))
                    .toList()
            ],
          ),

          //
        );
      },
    );
  }
}
