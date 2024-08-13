import 'package:flutter/material.dart';
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

          Navigator.push(
            context,
            routeToPage(
              AppWebView(
                "${module.url}&token=$token",
                module.name,
              ),
            ),
          );
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
