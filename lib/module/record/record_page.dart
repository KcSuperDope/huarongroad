import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/common/empty_data_widget.dart';
import 'package:huaroad/common/net_error_retry_widget.dart';
import 'package:huaroad/common/select_option.dart';
import 'package:huaroad/module/game/game.dart';
import 'package:huaroad/module/record/record_controller.dart';
import 'package:huaroad/module/record/record_list_item.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecordPage extends StatelessWidget {
  RecordPage({Key? key}) : super(key: key);
  final c = Get.put(RecordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: c.getTitle()),
      body: Obx(
        () => c.isLoadingError.value
            ? NetErrorRetryWidget(onRetry: () => c.refresh())
            : c.isEmptyData.value
                ? const EmptyDataWidget()
                : Column(
                    children: [
                      RecordListTitle(gameMode: c.gameMode),
                      Expanded(
                        child: SmartRefresher(
                          enablePullUp: true,
                          enablePullDown: true,
                          onRefresh: () => c.onRefresh(),
                          onLoading: () => c.onLoadMore(),
                          header: CustomHeader(builder: (BuildContext context, RefreshStatus? mode) {
                            return Image.asset("lib/assets/png/loading.gif", width: 60, height: 60);
                          }),
                          footer: CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
                            if (mode == LoadStatus.loading) {
                              return Image.asset("lib/assets/png/loading.gif", width: 60, height: 60);
                            } else {
                              return const SizedBox();
                            }
                          }),
                          controller: c.refreshController,
                          child: ListView.builder(
                            itemCount: c.dataList.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              final item = c.dataList[index];
                              return RecordListItem(item: item, index: index, onTap: (item) => c.toRecordDetail(item));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}

class RecordListTitle extends StatelessWidget {
  const RecordListTitle({super.key, required this.gameMode});

  final GameMode gameMode;

  @override
  Widget build(BuildContext context) {
    if (gameMode == GameMode.rank) {
      return _vsRecordListTitle();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      color: color_bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: Text(
              S.dengji.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              S.moves.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          Expanded(
            flex: 3,
            child: Bubble(
              values: [S.PlaywithGANKlotski.tr, S.PlaywithoutGANKlotski.tr, S.gamedonotfinish.tr],
              icons: const ["icon_record_device", "icon_record_mobile", "icon_record_dnf"],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.Score.tr, style: const TextStyle(fontSize: 13, color: color_minor_text)),
                  const SizedBox(width: 3),
                  Image.asset("lib/assets/png/icon_?.png", width: 12),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _vsRecordListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      color: color_bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(flex: 3, child: Text('')),
          Expanded(
            flex: 3,
            child: Text(
              S.moves.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(S.Score.tr,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: color_minor_text)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              S.Winloss.tr,
              style: const TextStyle(fontSize: 13, color: color_minor_text),
            ),
          ),
          const Expanded(flex: 1, child: Text(''))
        ],
      ),
    );
  }
}
