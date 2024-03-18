import 'package:flutter/material.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/utils/dimensions/dimensions.dart';
import 'package:task_planner/utils/fonts/font_size.dart';

class OnBoardingScrollView extends StatelessWidget {
  const OnBoardingScrollView({
    super.key,
    required this.i,
    required this.imgUrl,
  });

  final int i;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: Dimensions.getScreenHeight(context) * 0.05),
        SizedBox(
          height: Dimensions.getScreenHeight(context) * 0.24,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              onboardingTitle[i],
              style: FontDecors.getOnBoardingPageTitleTextStyle(context),
            ),
          ),
        ),
        Expanded(
            child: Image.asset(onboardingImagePaths[i],
                fit: BoxFit.fill,
                height: Dimensions.getScreenHeight(context),
                width: Dimensions.getScreenWidth(context))
            //firebase image access
            // Image.network(imgUrl,
            //     height: Dimensions.getScreenHeight(context),
            //     width: Dimensions.getScreenWidth(context),
            //     fit: BoxFit.fill,
            //     loadingBuilder: (context, child, loadingProgress) {
            //   if (loadingProgress == null) {
            //     return child;
            //   } else {
            //     return Image.asset(onboardingImagePaths[i],
            //         fit: BoxFit.fill,
            //         height: Dimensions.getScreenHeight(context),
            //         width: Dimensions.getScreenWidth(context));
            //   }
            // }, errorBuilder: (context, error, stackTrace) {
            //   return Image.asset(onboardingImagePaths[i],
            //       fit: BoxFit.fill,
            //       height: Dimensions.getScreenHeight(context),
            //       width: Dimensions.getScreenWidth(context));
            // }),
            ),
      ],
    );
  }
}
