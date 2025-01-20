import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/module/appliction/application_repository.dart';
import 'package:huaroad/module/appliction/banner_jump_handler.dart';
import 'package:huaroad/styles/styles.dart';

class ApplicationBanner extends StatelessWidget {
  ApplicationBanner({super.key, required this.banners});

  List<BannerModel> banners;

  @override
  Widget build(BuildContext context) {
    return Obx(() => banners.isNotEmpty
        ? SizedBox(
            height: (MediaQuery.of(context).size.width - ui_page_padding * 2) * 143 / 343,
            child: Swiper(
              duration: 300,
              autoplayDelay: 5000,
              itemCount: banners.length,
              autoplay: true,
              onTap: (index) {
                ApplicationRepo.reportBannerClick(banners[index].id!);
                BannerJumpHandler.jump(banners[index]);
              },
              pagination: CustomSwiperPaginationBuilder(),
              itemBuilder: (BuildContext ctx, int index) {
                BannerModel bannerModel = banners[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CachedNetworkImage(imageUrl: bannerModel.image!, fit: BoxFit.fill),
                );
              },
            ),
          )
        : const SizedBox());
  }
}

/// 自定义页面指示器
class CustomSwiperPaginationBuilder extends SwiperPlugin {
  late Color? activeColor;
  late Color? color;
  final double space;
  final double size;
  final double activeSize;
  final double bottom;
  final AlignmentGeometry? alignment;
  final Key? key;
  final bool? inLeft;

  CustomSwiperPaginationBuilder({
    this.color = Colors.grey,
    this.activeColor = Colors.blue,
    this.space = 3.0,
    this.size = 10.0,
    this.activeSize = 11.0,
    this.bottom = 0.0,
    this.alignment = Alignment.center,
    this.key,
    this.inLeft = false,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    int activeIndex = config.activeIndex;
    List<Widget> list = [];
    for (var i = 0; i < config.itemCount; ++i) {
      if (activeIndex == i) {
        list.add(
          Container(
            key: Key('pagination_$i'),
            margin: EdgeInsets.all(space),
            child: PhysicalModel(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: activeSize,
                height: size,
                child: Image.asset("lib/assets/png/banner_icon_dot.png"),
              ),
            ),
          ),
        );
      } else {
        list.add(
          Container(
            key: Key('pagination_$i'),
            margin: EdgeInsets.all(space),
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset("lib/assets/png/banner_icon_dot_n.png"),
            ),
          ),
        );
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 15,
          right: 15,
          bottom: bottom,
          child: Container(
            alignment: inLeft! ? Alignment.centerLeft : alignment,
            color: Colors.transparent,
            child: Row(
              key: key,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: list,
            ),
          ),
        )
      ],
    );
  }
}
