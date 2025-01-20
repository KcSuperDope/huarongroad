import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:huaroad/assets/intl/intl.dart';
import 'package:huaroad/auto_size.dart';
import 'package:huaroad/route/pages.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/logger.dart';

void main() {
  init();
  runApp(const MyApp());
  AutoSize.init();
}

void init() async {
  LogUtil.init();
  await GetStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return GetMaterialApp(
            // title: S.Klotski.tr,
            getPages: AppPages.pages,
            theme: ThemeData(
              primarySwatch: getMaterialColor(Colors.white),
              scaffoldBackgroundColor: Colors.white,
            ),
            initialRoute: Routes.application_page,
            debugShowCheckedModeBanner: false,
            translations: Intl(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            defaultTransition: Transition.rightToLeft,
          );
        });
  }
}
