import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gold_shop/core/texts/words.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/colors/colors.dart';
import '../../../core/images/images.dart';
import '../../../core/utils/app_fonts.dart';
import '../controller/mediator_shops_map_.dart';

class MediatorShopsMapScreen extends GetView<MediatorShopsMapController> {
  const MediatorShopsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MediatorShopsMapController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppWord.mediatorShops,
          style: TextStyle(
            color: CustomColors.black,
            fontWeight: FontWeight.bold,
            fontSize: AppFonts.subTitleFont(context),
          ),
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: SvgPicture.asset(
              AppImages.moreIcon,
              fit: BoxFit.scaleDown,
            ),
          );
        }),
        elevation: 1,
        backgroundColor: CustomColors.white,
      ),
      body: WebViewWidget(
        controller: controller.webController,
      ),
    );
  }
}
