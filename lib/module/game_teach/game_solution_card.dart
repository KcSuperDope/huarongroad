import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/image_bg_button.dart';
import 'package:huaroad/module/appliction/application_banner.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/game_teach/game_teach_repository.dart';
import 'package:huaroad/module/level/level_hard_handler.dart';
import 'package:huaroad/route/routes.dart';
import 'package:huaroad/styles/styles.dart';

class GameSolutionCard extends StatefulWidget {
  const GameSolutionCard({super.key, this.models, required this.index, required this.gameType});

  final List<GameSolutionInfoModel>? models;
  final int index;
  final GameType gameType;

  @override
  State<GameSolutionCard> createState() => GameSolutionCardState();
}

class GameSolutionCardState extends State<GameSolutionCard> {
  List<GameSolutionInfoModel>? _models;
  int _limitLevel = 0;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _models = widget.models;

    _limitLevel = widget.index >= 2 ? 40 * (widget.index - 1) : 20;
    final currentLevel = LevelHardHandler().lastLevel.value;
    _isOpen = widget.gameType == GameType.hrd ? (widget.index == 0 ? true : currentLevel > _limitLevel) : true;

    _isOpen = true;
  }

  void update(List<GameSolutionInfoModel> models) {
    setState(() {
      _models = models;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isOpen
        ? _models!.isEmpty
            ? Center(
                child: Column(children: [
                  const SizedBox(height: 153),
                  Image.asset("lib/assets/png/1.0.7/go_to_level.png", width: 200, height: 200),
                  const SizedBox(height: 12),
                  const Text("敬请期待", style: TextStyle(color: color_main_text, fontSize: 16)),
                ]),
              )
            : ListView.builder(
                itemCount: _models!.length + 2,
                itemBuilder: (BuildContext btc, int index) {
                  if (index == 0) {
                    return const GameSolutionHeaderWidget();
                  } else if (index == _models!.length + 1) {
                    return Container(
                      margin: const EdgeInsets.only(top: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 205,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: color_main,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("lib/assets/png/icon_social_comment.png", width: 24, height: 24),
                                  const SizedBox(width: 2),
                                  const Text("解法讨论", style: TextStyle(color: color_main_text, fontSize: 16)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return GameSolutionInfoWidget(model: widget.models![index - 1]);
                  }
                },
              )
        : LockLevelWidget(
            onTap: () => Get.toNamed(Routes.level_page, arguments: GameType.hrd),
            limitLevel: _limitLevel,
          );
  }
}

class GameSolutionHeaderWidget extends StatelessWidget {
  const GameSolutionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: color_FFEDED,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: const Text(
        "注：该难度下的所有棋局，均可按以下步骤尝试进行复原；根据棋局不同，以下某些步骤可跳过。",
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}

class GameSolutionInfoWidget extends StatelessWidget {
  const GameSolutionInfoWidget({super.key, required this.model});

  final GameSolutionInfoModel model;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.title != null)
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: 16,
                child: Text(model.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Center(child: Image.asset("lib/assets/png/1.0.5/title_bg.png", fit: BoxFit.fitWidth))
            ],
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.contentText != null)
                Text(model.contentText!, style: const TextStyle(fontSize: 14, height: 1.6), textAlign: TextAlign.start),
              SizedBox(height: model.contentText != null ? 16 : 0),
              if (model.type == GameSolutionInfoType.image)
                Column(children: [
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 78),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: CachedNetworkImage(
                        imageUrl: GameTeachRepo().solImageUrl + model.images![0],
                        placeholder: (ctx, url) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: Get.width - 94 * 2,
                            height: (Get.width - 94 * 2) / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                        errorWidget: (ctx, url, error) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: Get.width - 94 * 2,
                            height: (Get.width - 94 * 2) / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              if (model.type == GameSolutionInfoType.images)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: CachedNetworkImage(
                        imageUrl: GameTeachRepo().solImageUrl + model.images![0],
                        width: (width - 74) / 2,
                        placeholder: (ctx, url) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: (width - 74) / 2,
                            height: (width - 74) / 2 / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                        errorWidget: (ctx, url, error) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: (width - 74) / 2,
                            height: (width - 74) / 2 / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    const Text("OR", style: TextStyle(fontSize: 24, fontFamily: "VonwaonBitmap")),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: CachedNetworkImage(
                        imageUrl: GameTeachRepo().solImageUrl + model.images![1],
                        width: (width - 74) / 2,
                        placeholder: (ctx, url) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: (width - 74) / 2,
                            height: (width - 74) / 2 / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                        errorWidget: (ctx, url, error) {
                          return Image.asset(
                            "lib/assets/png/1.0.7/place.png",
                            width: (width - 74) / 2,
                            height: (width - 74) / 2 / 25 * 31,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              if (model.type == GameSolutionInfoType.button)
                Obx(() => SizedBox(
                      width: MediaQuery.of(context).size.width - 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: GameTeachRepo().topOrBottom.value == 1 ? color_main : Colors.transparent,
                                        width: 4)),
                                child: GestureDetector(
                                  onTap: () => GameTeachRepo().buttonTop(context),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    child: CachedNetworkImage(
                                      imageUrl: GameTeachRepo().solImageUrl + model.images![0],
                                      width: (width - 86) / 2,
                                      placeholder: (ctx, url) {
                                        return Image.asset(
                                          "lib/assets/png/1.0.7/place.png",
                                          width: (width - 86) / 2,
                                          height: (width - 86) / 2 / 25 * 31,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                      errorWidget: (ctx, url, error) {
                                        return Image.asset(
                                          "lib/assets/png/1.0.7/place.png",
                                          width: (width - 86) / 2,
                                          height: (width - 86) / 2 / 25 * 31,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ImageBgButton(
                                  text: "上方",
                                  isSelected: GameTeachRepo().topOrBottom.value == 1,
                                  onTap: () => GameTeachRepo().buttonTop(context))
                            ],
                          ),
                          const Text("OR", style: TextStyle(fontSize: 24, fontFamily: "VonwaonBitmap")),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: GameTeachRepo().topOrBottom.value == 2 ? color_main : Colors.transparent,
                                        width: 4)),
                                child: GestureDetector(
                                  onTap: () => GameTeachRepo().buttonBottom(context),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    child: CachedNetworkImage(
                                      imageUrl: GameTeachRepo().solImageUrl + model.images![1],
                                      width: (width - 86) / 2,
                                      placeholder: (ctx, url) {
                                        return Image.asset(
                                          "lib/assets/png/1.0.7/place.png",
                                          width: (width - 86) / 2,
                                          height: (width - 86) / 2 / 25 * 31,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                      errorWidget: (ctx, url, error) {
                                        return Image.asset(
                                          "lib/assets/png/1.0.7/place.png",
                                          width: (width - 86) / 2,
                                          height: (width - 86) / 2 / 25 * 31,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ImageBgButton(
                                  text: "下方",
                                  isSelected: GameTeachRepo().topOrBottom.value == 2,
                                  onTap: () => GameTeachRepo().buttonBottom(context))
                            ],
                          )
                        ],
                      ),
                    )),
              if (model.type == GameSolutionInfoType.cycle)
                Column(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.width - ui_page_padding * 2) * 202 / 335,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Swiper(
                        itemCount: model.cycleData!.length,
                        autoplay: false,
                        loop: false,
                        pagination: CustomSwiperPaginationBuilder(inLeft: true, bottom: 15),
                        itemBuilder: (BuildContext ctx, int index) {
                          Map<String, dynamic> data = model.cycleData![index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: const BoxDecoration(
                              color: color_bg,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        child: Stack(
                                          children: [
                                            Visibility(
                                              visible: index == 0,
                                              child: Positioned(
                                                bottom: 0,
                                                child: Container(width: 48, height: 10, color: color_main),
                                              ),
                                            ),
                                            Text(
                                              data["title"],
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(data["content"], style: const TextStyle(fontSize: 14)),
                                      const SizedBox(height: 10),
                                      Visibility(
                                        visible: index == 0,
                                        child: GestureDetector(
                                          child: SizedBox(
                                            width: 140,
                                            height: 30,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text("左滑查看解决方案", style: TextStyle(color: color_minor_text)),
                                                  const SizedBox(width: 4),
                                                  Image.asset("lib/assets/png/icon_next.png", width: 6, height: 10)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      child: CachedNetworkImage(
                                        imageUrl: GameTeachRepo().solImageUrl + data["image"],
                                        placeholder: (ctx, url) {
                                          return Image.asset("lib/assets/png/1.0.7/place.png");
                                        },
                                        errorWidget: (ctx, url, error) {
                                          return Image.asset("lib/assets/png/1.0.7/place.png");
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 36),
              if (model.bottomText != null)
                Text(model.bottomText ?? "", style: const TextStyle(fontSize: 14), textAlign: TextAlign.start),
            ],
          ),
        )
      ],
    );
  }
}

class LockLevelWidget extends StatelessWidget {
  LockLevelWidget({super.key, required this.onTap, required this.limitLevel});

  VoidCallback onTap;
  int limitLevel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 153),
          Image.asset("lib/assets/png/1.0.7/go_to_level.png", width: 200, height: 200),
          Text("通关闯关挑战[$limitLevel]解锁", style: const TextStyle(fontSize: 16, color: color_main_text)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => onTap(),
            child: Container(
              alignment: Alignment.center,
              width: 165,
              height: 40,
              decoration: const BoxDecoration(
                color: color_main,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Text("前往挑战", style: TextStyle(color: color_main_text, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
