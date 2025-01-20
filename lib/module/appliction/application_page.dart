import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/appliction/application_banner.dart';
import 'package:huaroad/module/appliction/application_controller.dart';
import 'package:huaroad/module/appliction/application_device_widget.dart';
import 'package:huaroad/module/appliction/application_item_widget.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ApplicationPage extends StatelessWidget {
  ApplicationPage({Key? key}) : super(key: key);
  final c = Get.put(ApplicationController());

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('ApplicationPage'),
      onVisibilityChanged: c.onVisibilityChanged,
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: EnvConfig.env == Env.dev || EnvConfig.env == Env.test
        //     ? MenuAnchor(
        //         builder: (BuildContext context, MenuController menuController, Widget? child) {
        //           return UnconstrainedBox(
        //             child: OutlinedButton(
        //               onPressed: () {
        //                 if (menuController.isOpen) {
        //                   menuController.close();
        //                 } else {
        //                   menuController.open();
        //                 }
        //               },
        //               style: ButtonStyle(
        //                   padding: MaterialStateProperty.all(EdgeInsets.zero),
        //                   minimumSize: MaterialStateProperty.all(const Size(96, 30)),
        //                   side: MaterialStateProperty.all(const BorderSide(color: Colors.black)),
        //                   shape: MaterialStateProperty.all(
        //                       RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)))),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Obx(() => Text(
        //                         c.language.value.languageCode,
        //                         style:
        //                             const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        //                       )),
        //                   const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //         menuChildren: c.languages
        //             .map((e) => MenuItemButton(
        //                   onPressed: () {
        //                     c.language.value = e;
        //                     Get.updateLocale(c.language.value);
        //                   },
        //                   child: MenuAcceleratorLabel(e.languageCode),
        //                 ))
        //             .toList(),
        //       )
        //     : null,

        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     List<int> initialState = [1, 3, 6, 2, 4, 0];
        //     List<int> goalState = [1, 1, 1, 1, 1, 0];
        //
        //     List<int> path = sol(initialState, goalState);
        //     String pathDir = "\n";
        //     int index = 0;
        //     for (var element in path) {
        //       if (element == 0) pathDir += "下,";
        //       if (element == 1) pathDir += "上,";
        //       if (element == 2) pathDir += "右,";
        //       if (element == 3) pathDir += "左,";
        //       index++;
        //       if (index % 4 == 0) pathDir += "\n";
        //     }
        //     LogUtil.d(pathDir);
        //   },
        //   child: Container(
        //     width: 100,
        //     height: 100,
        //     color: Colors.red,
        //   ),
        // ),

        body: Obx(() => c.isShow.value
            ? SafeArea(
                child: NestedScrollView(
                  physics: const ClampingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 21),
                            ApplicationDeviceWidget(onTapDeviceName: () => Get.toNamed(Routes.device_info_page)),
                            const SizedBox(height: 21),
                            ApplicationBanner(banners: c.banners),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 58,
                                child: TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  controller: c.tabController,
                                  unselectedLabelColor: color_mid_text,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorColor: Colors.transparent,
                                  padding: const EdgeInsets.only(top: 10),
                                  labelStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  tabs: c.tabs
                                      .map((element) => MainTab(text: element, currentText: c.currentTab))
                                      .toList(),
                                )),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                      controller: c.tabController,
                      children: c.items
                          .map((element) => ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  ApplicationTeachEntry(gameType: c.guideEntryTypes[c.items.indexOf(element)]),
                                  const SizedBox(height: 19),
                                  Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: element.map((item) => ApplicationItemWidget(item: item)).toList()),
                                ],
                              ))
                          .toList()),
                ),
              )
            : const SizedBox()),
      ),
    );
  }
}

class MainTab extends StatelessWidget {
  const MainTab({Key? key, required this.text, required this.currentText}) : super(key: key);
  final String text;
  final RxString currentText;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Stack(
              children: [
                Visibility(
                  visible: currentText.value == text,
                  child: Positioned(left: 2, top: 2, child: Text(text.tr, style: const TextStyle(color: color_main))),
                ),
                Text(text.tr),
              ],
            ),
            Visibility(
              visible: currentText.value == text,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("lib/assets/png/1.0.5/tab_choose.png", width: 24, height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class ApplicationTeachEntry extends StatelessWidget {
  const ApplicationTeachEntry({super.key, required this.gameType});

  final GameType gameType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.game_desc_page, arguments: {"type": gameType, "hard": 1, "notJumpSolution": true}),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: Get.width - 32,
            height: 30,
            child: Image.asset(
              "lib/assets/png/1.0.7/teach_entry_bg.png",
              width: Get.width - 32,
              height: 30,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: Get.width - 32,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("lib/assets/png/1.0.5/application_teach_enter.png", width: 16, height: 16),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: Get.width - 120,
                      child: Text(
                        gameType == GameType.hrd ? S.HrdTeachTitle.tr : S.NumTeachTitle.tr,
                        style: const TextStyle(color: color_mid_text),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Image.asset("lib/assets/png/1.0.5/icon_arrow_green.png", width: 16, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
