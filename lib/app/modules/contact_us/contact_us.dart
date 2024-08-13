import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/modules/global_used_widgets/widget_methods.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/widgets/app_bars.dart';
import 'package:step/app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          getAppPostionedBackground(context),
          SizedBox(
            height: getScreenHeight(context),
            child: Column(
              children: [
                NormalAppBar(
                  title: getL10(context).callUs,
                  icon: "assets/images/callus_ic.svg",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // getHeightSpace(getTopPadding(context) + 10),

                        /// the back button
                        getHeightSpace(20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          child: SizedBox(
                            height: getScreenSize(context).height -
                                ((getTopPadding(context) + 40)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      /// this just to align center

                                      Center(
                                        child: SizedBox(
                                          // height: getScreenSize(context).height * 0.15,
                                          child: Image.asset(
                                            "assets/images/app_logo.png",
                                            width: 100,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      getHeightSpace(10),
                                      Text(
                                        getL10(context).ministryOfManpower,
                                        style: getThemeData(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              height: 0.9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        "${getL10(context).vocationalTrainingAcademy} ${getL10(context).academy}",
                                        style: getThemeData(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold
                                                // height: 0.9,
                                                ),
                                      ),
                                    ],
                                  ),
                                  getHeightSpace(20),
                                  getTitleText(
                                    getL10(context).youAreWelcomeToContactUs,
                                    context,
                                  ),
                                  getHeightSpace(10),
                                  getNormalText(
                                    getL10(context)
                                        .ifYouHaveAnyQuestionsOrComments,
                                    context,
                                  ),
                                  SizedBox(
                                    width: getScreenSize(context).width * 0.9,
                                    child: getNormalText(
                                        getL10(context).orIfYouNeedAssistance,
                                        context),
                                  ),
                                  getHeightSpace(20),
                                  Divider(
                                    color: getThemeData(context)
                                        .colorScheme
                                        .onBackground,
                                    thickness: 1,
                                  ),
                                  getHeightSpace(20),
                                  getTitleText(
                                    getL10(context).timesOfWork,
                                    context,
                                  ),
                                  getNormalText(
                                      "الأحد - الخميس : 9 ص - 5.م", context,
                                      weight: FontWeight.bold),
                                  getNormalText("الجمعة-السبت : مغلق", context,
                                      weight: FontWeight.bold),
                                  getHeightSpace(20),
                                  Divider(
                                    color: getThemeData(context)
                                        .colorScheme
                                        .onBackground,
                                    thickness: 1,
                                  ),
                                  getHeightSpace(20),
                                  getTitleText(
                                      getL10(context).contactUsThroughEmail,
                                      context),
                                  getNormalText("test@yahoo.com", context,
                                      weight: FontWeight.bold),
                                  getNormalText("test@yahoo.com", context,
                                      weight: FontWeight.bold),
                                  getHeightSpace(
                                      getScreenSize(context).height * 0.07),
                                  Center(
                                    child: getTitleText(
                                        getL10(context)
                                            .availablePlatformsToContactUs,
                                        context),
                                  ),
                                  getHeightSpace(10),
                                  Center(
                                    child: SizedBox(
                                      width: getScreenSize(context).width * 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset("assets/images/wh_ic.png")
                                              .onTap(() {
                                            launchUrl(Uri.parse(
                                                "https://manpoweracademy.nitg-eg.com/"));
                                          }),
                                          Image.asset("assets/images/fb_ic.png")
                                              .onTap(() {
                                            launchUrl(Uri.parse(
                                                "https://manpoweracademy.nitg-eg.com/"));
                                          }),
                                          Image.asset(
                                                  "assets/images/insta_ic.png")
                                              .onTap(() {
                                            launchUrl(Uri.parse(
                                                "https://manpoweracademy.nitg-eg.com/"));
                                          }),
                                          Image.asset("assets/images/yt_ic.png")
                                              .onTap(() {
                                            launchUrl(Uri.parse(
                                                "https://manpoweracademy.nitg-eg.com/"));
                                          }),
                                          Image.asset("assets/images/teleg.png")
                                              .onTap(() {
                                            launchUrl(Uri.parse(
                                                "https://manpoweracademy.nitg-eg.com/"));
                                          }),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
