import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/appliction/application_controller.dart';
import 'package:huaroad/styles/styles.dart';

class ApplicationItemWidget extends StatelessWidget {
  const ApplicationItemWidget({Key? key, required this.item}) : super(key: key);
  final ApplicationItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: ExactAssetImage(item.bg), alignment: Alignment.topCenter),
        ),
        width: (Get.width - 44) / 2,
        height: (Get.width - 44) / 2 * 150 / 165,
        padding: const EdgeInsets.only(top: 16, left: 14, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              item.slogan.tr,
              style: TextStyle(
                  fontSize: ["zh", "ja", "hk"].contains(Get.locale?.languageCode) ? 13 : 10,
                  color: color_mid_text,
                  overflow: TextOverflow.ellipsis),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
