import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/enums.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/data/default_values.dart';
import 'package:step/app/core/data/models/course_member.dart';
import 'package:step/app/core/themes/colors.dart';
import 'package:step/app/modules/course_profile/course_pages/course_member_profile.dart';
import 'package:step/app/utils/helper_funcs.dart';
import 'package:step/app/utils/routing_utils.dart';
import 'package:step/app/widgets/status_widgets.dart';
import 'package:step/app/widgets/texts.dart';

import '../../../core/data/api/ApiCall.dart';
import '../../../widgets/bottom_sheets/change_password_for_student_course_member.dart';

class CourseMembersWidget extends StatefulWidget {
  const CourseMembersWidget(
    this.courseId, {
    super.key,
  });

  final String courseId;

  @override
  State<CourseMembersWidget> createState() => _CourseMembersWidgetState();
}

class _CourseMembersWidgetState extends State<CourseMembersWidget> {
  List<CourseMember> members = [];
  final state = ValueNotifier(AppViewState.busy);

  getMembers() async {
    try {
      state.value = AppViewState.busy;
      final response = await CallApi.getRequest(
        "${StaticData.baseUrl}/academyApi/json.php?function=get_enrolled_users_members&courseID=${widget.courseId}",
      );
      if (response['data'] != null) {
        members = (response['data'] as List)
            .map((e) => CourseMember.fromJson(e))
            .cast<CourseMember>()
            .toList();
        state.value = AppViewState.idle;
      }
    } catch (e) {
      state.value = AppViewState.error;
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: state,
        builder: (context, state, child) {
          return getWidgetDependsInAppViewState(
            state,
            onClick: null,
            Builder(builder: (context) {
              if (members.isNotEmpty) {
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) => Container(
                    // height: 100,
                    width: getScreenWidth(context) * 0.8,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: getThemeData(context).colorScheme.background,
                      boxShadow: getBoxShadow(
                        context,
                        color: getThemeData(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              routeToPage(
                                CourseMemberProfile(members[index]),
                              ),
                            );
                          },
                          tileColor: kOnPrimary,
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  members[index].userImage ??
                                      DefaultValues.image,
                                ),
                              ),
                            ),
                          ),
                          title: getNormalText(
                            members[index].fullName,
                            weight: FontWeight.bold,
                            context,
                          ),
                          subtitle: getNormalText(members[index].id, context,
                              color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: Text(getL10(context).changePassword),
                              onPressed: () {
                                showBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white.withOpacity(0),
                                  constraints: BoxConstraints(
                                      maxHeight: getScreenHeight(context)),
                                  builder: (context) {
                                    return ChangeCourseMemberPasswordBottomSheet(
                                      members[index],
                                    );
                                  },
                                );
                              },
                            ),
                            /*    if (members[index].token != null)
                              ElevatedButton(
                                child: Text(getL10(context).editStudentData),
                                onPressed: () {
                                  ProfileController controller =
                                      ProfileController();
                                  controller.setDataForBottomSheet();
                                */

                            /*  showBottomSheet(
                                    context: context,
                                    constraints: BoxConstraints(
                                      maxHeight: getScreenHeight(context) -
                                          kToolbarHeight,
                                    ),
                                    builder: (contxt) => EditProfileBottomSheet(
                                      controller: controller,
                                    ),
                                  );*/
                            /*
                                  Navigator.of(context).push(
                                    routeToPage(
                                      EditProfileBottomSheet(
                                        controller: controller,
                                      ),
                                    ),
                                  );
                                },
                              ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Center(
                    child: getNormalText(
                        "Oops..there is no students in this course.", context));
            }),
          );
        });
  }
}
