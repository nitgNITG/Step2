import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/data/models/course_details.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/course_profile/course_profile_controller.dart';
import 'package:step/app/modules/open_pdf/open_pdf.dart';
import 'package:step/app/modules/web_view/view/web_view.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/utils/routing_utils.dart';
import 'package:step/app/widgets/messages.dart';
import 'package:step/app/widgets/texts.dart';

class ModuleItem extends StatelessWidget {
  const ModuleItem({super.key, required this.module});

  final Module module;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Image.network(
            module.modicon ?? StaticData.imagePlaceHolder,
            errorBuilder: (ee,rr,cc)=>const Icon(Icons.error),
            width: 30,
          ),
          /* Icon(
            getIcon(),
          ),*/
          getWidthSpace(10),
          getNormalText(
            module.name,
            context,
          ),
        ],
      ),
    ).onTap(() {
      final controller =
          Provider.of<CourseProfileController>(context, listen: false);

      if (controller.isUserTeacherOfThisCourseOrAdminOrStudentSubscribed()) {
       /* if (module.modname == "resource") {
          final token = controller.getLoggedUser().token;
          // print("////${module.url}&token=$token");
          Navigator.push(
            context,
            routeToPage(
              OpenPdfPage(
                fileUrl: "${module.fileDetails!.fileurl}&token=$token",
                title: module.name,
              ),
            ),
          );
        } else */{
          final token = controller.getLoggedUser().token;
          if(module.avail==true)
          Navigator.push(
            context,
            routeToPage(
              AppWebView(
                "${module.url}&token=$token",
                module.name,
              ),
            ),
          );
          if(module.avail==false) showMyDialog(context,module.avail_message);

        }
      } else {
        showSnackBar(
          context,
          getL10(context).subscribeToShowCourseContent,
          color: kSecondaryColor,
        );
      }
    });
  }

  IconData? getIcon() {
    if (module.modname == "resource") {
      return Icons.picture_as_pdf_outlined;
    } else if (module.modname == "page")
      return Icons.play_circle;
    else if (module.modname == "quiz")
      return Icons.quiz_outlined;
    else
      return Icons.web;
  }
}
showMyDialog(context,message) {
  showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 2.0,
        sigmaY: 1.5,
      ),
      child: AlertDialog(
        backgroundColor:   Color(0xff00FFFF),
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
                "$message",
                context,
                // color: kOnPrimary,
              ),
              const Spacer(),

            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.15),

  );
}
