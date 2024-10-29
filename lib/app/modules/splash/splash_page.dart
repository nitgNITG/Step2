import 'package:step/app/modules/splash/splash_controller.dart';
import 'package:step/app/utils/helper_funcs.dart';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashController controller = SplashController();
  @override
  void initState() {
    super.initState();
    controller.navigate(context);
  }

  // requestNotificationPermission() {
  //   FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox.expand(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/splash_background.png",
              fit: BoxFit.fill,
              width: getScreenSize(context).width,
              height: getScreenSize(context).height,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getHeightSpace(MediaQuery.paddingOf(context).top),
                  Image.asset(
                    "assets/images/app_logo.png",
                    width: getScreenWidth(context) * 0.65,
                    fit: BoxFit.fill,
                  ),
                  getHeightSpace(10),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
