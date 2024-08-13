import 'package:flutter/material.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/data/models/course_member.dart';

import '../../core/data/api/ApiCall.dart';
import '../../utils/helper_funcs.dart';
import '../form_fields.dart';
import '../messages.dart';

class ChangeCourseMemberPasswordBottomSheet extends StatefulWidget {
  const ChangeCourseMemberPasswordBottomSheet(this.member, {super.key});

  final CourseMember member;

  @override
  State<ChangeCourseMemberPasswordBottomSheet> createState() =>
      _ChangeCourseMemberPasswordBottomSheetState();
}

class _ChangeCourseMemberPasswordBottomSheetState
    extends State<ChangeCourseMemberPasswordBottomSheet> {
  final TextEditingController textEditingController = TextEditingController();
  Color barrierBackground = Colors.black.withOpacity(0.8);
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (mounted) focusNode.requestFocus();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: InkWell(
          onTap: () async {
            setState(() {
              barrierBackground = Colors.black.withOpacity(0);
            });
            await Future.delayed(const Duration(microseconds: 100));
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          child: Container(
            color: barrierBackground,
          ),
        )),
        Container(
          color: getThemeData(context).colorScheme.background,
          child: Column(
            children: [
              getHeightSpace(10),
              SizedBox(
                width: getScreenWidth(context) * 0.8,
                child: TextFormFieldWidget(
                  title: getL10(context).newPassword,
                  controller: textEditingController,
                  focusNode: focusNode,
                  titleColor: getThemeData(context).colorScheme.onBackground,
                  fillColor: Colors.grey,
                ),
              ),
              getHeightSpace(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(getL10(context).cancel)),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        FocusManager.instance.primaryFocus?.unfocus();
                        final response = await CallApi.getRequest(
                            "${StaticData.baseUrl}/academyApi/json.php?function=changeUserPassword&new_password=${textEditingController.text.toString()}&user_id=${widget.member.id}");
                        if (response['data'] != null) {
                          Navigator.of(context).pop();
                          await Future.delayed(
                            const Duration(
                              milliseconds: 200,
                            ),
                          );

                          showSnackBar(
                            context,
                            getL10(context).updatedSuccesfull,
                            color: Colors.green,
                          );
                        }
                      } catch (e) {
                        showSnackBar(
                          context,
                          getL10(context).sorryProlemFromUs,
                        );
                      }
                    },
                    child: Text(
                     "Save new password",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
