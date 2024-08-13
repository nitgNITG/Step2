import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/global_providers/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/themes/colors.dart';
import '../utils/helper_funcs.dart';

class NormalAppBar extends StatelessWidget {
  const NormalAppBar({
    super.key,
    required this.title,
    this.subTitle,
    this.obacity = 1.0,
    this.trailing,
    this.icon,
  });

  final String title;
  final String? subTitle, icon;
  final double obacity;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          getHeightSpace(getTopPadding(context) + 10),
          Row(
            children: [
              trailing ?? Container(),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (icon != null)
                          SvgPicture.asset(
                            icon!,
                            colorFilter: ColorFilter.mode(
                              kOnPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        getWidthSpace(10),
                        Text(
                          title,
                          style: getThemeData(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                color: kOnPrimary,
                                fontSize: 18,
                              ),
                        ),
                        getWidthSpace(10)
                      ],
                    ),
                    if (subTitle != null)
                      Row(
                        children: [
                          getWidthSpace(10),
                          Text(
                            subTitle!,
                            style: getThemeData(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kOnPrimary.withOpacity(0.7),
                                    fontSize: 12,
                                    height: 1.5),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              getWidthSpace(5),
              const Spacer(),
              if (Navigator.of(context).canPop())
                RotatedBox(
                  quarterTurns:
                      Provider.of<LocalizationProvider>(context, listen: false)
                                  .getAppLocale()
                                  .languageCode ==
                              "ar"
                          ? 2
                          : 0,
                  child: SvgPicture.asset(
                    "assets/images/back_button.svg",
                    colorFilter: ColorFilter.mode(
                      kOnPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ).onTap(() {
                  Navigator.of(context).pop();
                }),
              getWidthSpace(5)
            ],
          ),
        ],
      ),
    );
  }
}
