import 'dart:math';

import 'package:flutter/material.dart';
import 'package:huaroad/styles/styles.dart';

class LevelScrollPage extends StatefulWidget {
  static const String ROUTE = 'category';

  const LevelScrollPage({super.key});

  @override
  _LevelScrollPageState createState() => _LevelScrollPageState();
}

class _LevelScrollPageState extends State<LevelScrollPage> with AutomaticKeepAliveClientMixin {
  late List<FirstCategory> pCategory;

  bool isPageScrolling = false;

  double outOfTopExtent = 0;
  double outOfBottomExtent = 0;
  final maxOutOfExtent = 80;

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(width: MediaQuery.of(context).size.width, height: 44, color: Colors.white),
            _buildMain(),
          ],
        ),
      ),
    );
  }

  _buildMain() {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: const Color(0xFFF7F7F7),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Container(
            //     color: Colors.white,
            //     width: 96.5,
            //     child: FirstCategoryList(pCategory, (index) => _selectCategory(index))),
            // Container(color: Colors.grey, width: 12),
            Expanded(child: _buildCategoryChildren())
          ],
        ),
      ),
    );
  }

  _selectCategory(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    isPageScrolling = false;
  }

  final _pageController = PageController();

  _buildCategoryChildren() {
    return PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: pCategory.length,
        itemBuilder: (ctx, index) => _buildSecCategoryItem(index));
  }

  _buildSecCategoryItem(int index) {
    List<SecCategory> secCategories = pCategory[index].children;
    if (secCategories == null) {
      return Container();
    }
    return Listener(
      onPointerUp: (event) {
        var prePage = _pageController.page!.toInt() - 1;
        var nextPage = _pageController.page!.toInt() + 1;

        if (outOfBottomExtent > 0 && outOfBottomExtent > maxOutOfExtent && nextPage < pCategory.length) {
          _selectCategory(nextPage);
        }

        if (outOfTopExtent > 0 && outOfTopExtent > maxOutOfExtent && prePage >= 0) {
          _selectCategory(prePage);
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          outOfTopExtent = notification.metrics.extentAfter - notification.metrics.maxScrollExtent;
          outOfBottomExtent = notification.metrics.extentBefore - notification.metrics.maxScrollExtent;

          return true;
        },
        child: ListView.builder(
          key: ValueKey<int>(index),
          itemCount: secCategories.length,
          itemBuilder: (ctx, index) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 8.0, right: 12.0, bottom: 10.0),
                  width: double.maxFinite,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(right: 12, top: 12),
                  child: Text(secCategories[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0, color: Color(0xff333333))),
                ),
              ),
              _buildThirdCate(secCategories[index])
            ],
          ),
        ),
      ),
    );
  }

  void _getCategory() async {
    List<FirstCategory> res = [];
    for (int i = 0; i < 10; i++) {
      List<SecCategory> firstChildren = [];
      for (int j = 0; j < Random().nextInt(10); j++) {
        List<ThirdCategory> secondChildren = [];
        for (int k = 0; k < Random().nextInt(20); k++) {
          secondChildren.add(ThirdCategory(id: 2, name: "第$k关", icon: "", level: 3, logId: "1", targetUrl: ""));
        }
        firstChildren.add(SecCategory(id: 1, name: "难度$j", icon: "", level: 1, children: secondChildren));
      }
      res.add(FirstCategory(id: 0, name: "name", icon: "", level: 0, children: firstChildren));
    }

    setState(() {
      pCategory = res;
    });
  }

  _buildThirdCate(SecCategory secCategory) {
    List<ThirdCategory> thirdCategory = secCategory.children;
    if (thirdCategory == null) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.only(top: 8.0, left: 10.0, bottom: 16.0, right: 10.0),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5.0))),
      width: MediaQuery.of(context).size.width - (12.0 * 2),
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 2.0,
        alignment: WrapAlignment.start,
        children: _buildThirdCategoryList(thirdCategory),
      ),
    );
  }

  List<Widget> _buildThirdCategoryList(List<ThirdCategory> thirdCategory) {
    var thirdCateWidth = (MediaQuery.of(context).size.width - 96.5 - (12.0 * 2) - (10.0 * 2) - (1.0)) / 3;
    List<Widget> thirdCategoryList = [];
    for (int i = 0; i < thirdCategory.length; i++) {
      var thirdCate = thirdCategory[i];
      thirdCategoryList.add(Container(
        width: thirdCateWidth,
        child: GestureDetector(
          onTap: () => _clickCategory(thirdCate, i),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 70.0,
                height: 60.0,
                color: color_main,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 10.0, right: 10.0),
              child: Text(
                thirdCate.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10.0, color: Color(0xff4F4F4F)),
              ),
            )
          ]),
        ),
      ));
    }
    return thirdCategoryList;
  }

  _clickCategory(ThirdCategory thirdCate, int index) async {}

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class FirstCategoryList extends StatefulWidget {
  List<FirstCategory> firstCategory;
  CateChooser cateChooser;

  FirstCategoryList(this.firstCategory, this.cateChooser);

  @override
  _FirstCategoryListState createState() {
    return _FirstCategoryListState();
  }
}

class _FirstCategoryListState extends State<FirstCategoryList> {
  int index = 0;
  var _controller = ScrollController();

  @override
  void initState() {
    // EventBusUtil().bus.on<CategoryChange>().listen((event) {
    //
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewPadding(
      removeTop: true,
      context: context,
      child: ListView.builder(
          controller: _controller,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.firstCategory.length,
          itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  _selectCate(index);
                },
                child: Container(
                  height: 60.0,
                  color: this.index == index ? Colors.grey : Colors.white,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                        child: Text(
                          widget.firstCategory[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: this.index == index ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 13,
                            color: this.index == index ? const Color(0xFFE2770C) : const Color(0xff4F4F4F),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 3.0),
                  ]),
                ),
              )),
    );
  }

  _selectCate(int index) {
    if (index == this.index) return;
    widget.cateChooser(index);

    int half = (widget.firstCategory.length - 1) ~/ 2;
    int toIndex = (index - half) > 0 ? index - half : 0;
    if (index > this.index && _controller.position.extentBefore != _controller.position.maxScrollExtent) {
      _controller.animateTo(44.0 * toIndex.toDouble(),
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }

    if (index < this.index && _controller.position.extentAfter != _controller.position.maxScrollExtent) {
      _controller.animateTo(44.0 * toIndex.toDouble(),
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
    setState(() {
      this.index = index;
    });
  }
}

typedef CateChooser = Function(int index);

class Category {
  Category({required this.records});

  List<FirstCategory> records;
}

class FirstCategory {
  FirstCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.children,
  });

  int id;
  String name;
  String icon;
  int level;
  List<SecCategory> children;
}

class SecCategory {
  SecCategory({required this.id, required this.name, required this.icon, required this.level, required this.children});

  int id;
  String name;
  String icon;
  int level;
  List<ThirdCategory> children;
}

class ThirdCategory {
  ThirdCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.logId,
    required this.targetUrl,
  });

  int id;
  String name;
  String icon;
  int level;
  String logId;
  String targetUrl;
}
