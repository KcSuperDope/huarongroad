import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/empty_data_widget.dart';
import 'package:huaroad/common/net_error_retry_widget.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/top_list/top_list_controller.dart';
import 'package:huaroad/module/top_list/top_list_item.dart';
import 'package:huaroad/module/top_list/top_list_model.dart';
import 'package:huaroad/module/top_list/top_title.dart';
import 'package:huaroad/net/env/env_config.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/bottom_action_sheet.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TopListPage extends StatelessWidget {
  TopListPage({super.key});

  final c = Get.put(TopListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "lib/assets/png/application_title_bg.png",
            repeat: ImageRepeat.repeat,
            fit: BoxFit.contain,
            height: Get.height / 2,
          ),
          SafeArea(
            bottom: false,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppBar(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 40,
                    child: SoundGestureDetector(
                      onTap: () {
                        BottomActionSheet.show(
                          title: S.Selectdate,
                          context: context,
                          actions: c.seasonList,
                          current: c.currentSeason.value,
                          onSelect: (item) {
                            if (item is SeasonModel) {
                              if (item == c.currentSeason.value) return;
                              c.currentSeason.value = item;
                              c.queryFromSeason();
                            }
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(c.currentSeason.value.title, style: TextStyle(color: Colors.black, fontSize: 13)),
                          const SizedBox(width: 4),
                          Image.asset("lib/assets/png/icon_next_down.png", width: 12, height: 12),
                        ],
                      ),
                    ),
                  ),
                  c.isLoadingError.value
                      ? NetErrorRetryWidget(onRetry: () => c.loadData())
                      : Expanded(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  TopListTitle(gameMode: c.gameMode, gameType: c.gameType),
                                  Positioned(
                                    top: -44,
                                    right: 0,
                                    child: Image.asset("lib/assets/png/icon_angle.png", width: 44, height: 44),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  child: c.rankList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: c.rankList.length,
                                          itemBuilder: (BuildContext ctx, int index) {
                                            final item = c.rankList[index];
                                            return TopListItem(item: item, index: index);
                                          },
                                        )
                                      : const EmptyDataWidget(),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
                                width: Get.width,
                                height: 34 + 60,
                                color: color_main_bg,
                                child: SizedBox(
                                  height: 60,
                                  child: TopListItem(item: c.myRank.value, index: 0, bgColor: color_main_bg),
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                c.gameName + S.rankinglist.tr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SoundGestureDetector(
                  onTap: () => c.onTapBack(),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                    child: Image.asset("lib/assets/png/back.png", width: 24, height: 24),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await c.tipController.showTooltip();
                  },
                  child: SuperTooltip(
                    elevation: 0.1,
                    shadowColor: color_main.withOpacity(0.6),
                    shadowBlurRadius: 20,
                    borderWidth: 0,
                    borderColor: Colors.white,
                    showBarrier: true,
                    barrierColor: Colors.transparent,
                    controller: c.tipController,
                    right: 4,
                    arrowTipDistance: 15.0,
                    arrowBaseWidth: 20.0,
                    arrowLength: 10.0,
                    fadeOutDuration: const Duration(milliseconds: 120),
                    fadeInDuration: const Duration(milliseconds: 0),
                    content: Text(
                      EnvConfig.env == Env.ggprod
                          ? S.UpdateruleseveryMondayupdatedata.tr
                          : S.UpdateruleseveryMondayupdatedataCHN.tr,
                      softWrap: true,
                      style: const TextStyle(color: color_main_text, fontSize: 14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                      child: Image.asset(
                        "lib/assets/png/icon_?_black.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
