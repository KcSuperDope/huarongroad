import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/image_text_button.dart';
import 'package:huaroad/module/appliction/application_page.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game_teach/game_solution_card.dart';
import 'package:huaroad/module/game_teach/game_teach_controller.dart';
import 'package:huaroad/module/game_teach/game_teach_repository.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/styles/styles.dart';

class GameTeachPage extends StatelessWidget {
  GameTeachPage({Key? key}) : super(key: key);
  final c = Get.put(GameTeachController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: c.gameType == GameType.hrd ? S.HrdTeachTitle.tr : S.NumTeachTitle.tr),
      // floatingActionButton: EnvConfig.env == Env.dev || EnvConfig.env == Env.prod
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
      //                   shape:
      //                       MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)))),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Obx(() => Text(
      //                         c.language.value.languageCode,
      //                         style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
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

      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 44,
              child: TabBar(
                isScrollable: true,
                controller: c.tabController,
                indicatorSize: TabBarIndicatorSize.label,
                padding: const EdgeInsets.only(top: 10),
                labelStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color_mid_text),
                tabs: c.tabs.map((element) => MainTab(text: element, currentText: c.currentTab)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: c.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListView(children: GameTeachRepo().sections.map((e) => GameDescSectionWidget(model: e)).toList()),
                  DefaultTabController(
                    length: 7,
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 44,
                            child: TabBar(
                                controller: c.subTabController,
                                isScrollable: true,
                                padding: const EdgeInsets.only(top: 10),
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.black),
                                unselectedLabelStyle: const TextStyle(fontSize: 13, color: color_minor_text),
                                tabs: c.subTabs
                                    .map((e) => SubTab(
                                          text: e,
                                          currentText: c.currentSubTab,
                                          index: c.subTabs.indexOf(e),
                                          gameType: c.gameType,
                                        ))
                                    .toList())),
                        Container(width: MediaQuery.of(context).size.width, height: 1, color: color_EEEEEE),
                        Obx(
                          () => Expanded(
                            child: TabBarView(
                              controller: c.subTabController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: GameTeachRepo()
                                  .solutionSections
                                  .map((e) => GameSolutionCard(
                                        models: e,
                                        index: GameTeachRepo().solutionSections.indexOf(e),
                                        gameType: c.gameType,
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GameDescSectionWidget extends StatelessWidget {
  const GameDescSectionWidget({Key? key, required this.model}) : super(key: key);

  final GameDescSectionModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
                left: 16,
                child: Text(model.title!.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            Center(child: Image.asset("lib/assets/png/1.0.5/title_bg.png", fit: BoxFit.fitWidth))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              children: model.smallSections.entries
                  .map((e) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          Text(e.value.tr,
                              style: const TextStyle(fontSize: 14, height: 1.6), textAlign: TextAlign.start),
                          if (e.key.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    ImageTextButton(
                                      onTap: () {
                                        NativeFlutterPlugin.instance
                                            .bannerJump({"jump_type": "topic", "jump_content": e.key});
                                      },
                                      text: S.Goto.tr,
                                      imagePath: "lib/assets/png/icon_next.png",
                                      imageSize: 12,
                                    )
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ))
                  .toList()),
        ),
        if (model.imagePath != null && model.imagePath!.isNotEmpty)
          Column(children: [
            const SizedBox(height: 14),
            Container(
                alignment: Alignment.center,
                child: GifView(image: AssetImage(model.imagePath!), width: Get.width - 94 * 2)),
            const SizedBox(height: 22),
          ]),
        const SizedBox(height: 14),
      ],
    );
  }
}

class SubTab extends StatefulWidget {
  const SubTab({
    Key? key,
    required this.text,
    required this.currentText,
    required this.index,
    required this.gameType,
  }) : super(key: key);
  final String text;
  final RxString currentText;
  final int index;
  final GameType gameType;

  @override
  State<SubTab> createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  int _limitLevel = 0;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _limitLevel = widget.index >= 2 ? 40 * (widget.index - 1) : 20;
    final currentLevel = LevelHardHandler().lastLevel.value;
    _isOpen = widget.gameType == GameType.hrd ? (widget.index == 0 ? true : currentLevel > _limitLevel) : true;

    _isOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.text.tr),
            const SizedBox(width: 4),
            Visibility(
              visible: !_isOpen,
              child: Image.asset("lib/assets/png/1.0.7/level_lock.png", width: 8, height: 10),
            ),
          ],
        ),
        Obx(
          () => Visibility(
            visible: widget.currentText.value == widget.text,
            child: Image.asset("lib/assets/png/1.0.7/tab_choose_line.png", width: 14, height: 5),
          ),
        ),
      ],
    );
  }
}
