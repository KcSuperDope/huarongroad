import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/module/mine/mine_controller.dart';
import 'package:huaroad/styles/styles.dart';

class MinePage extends StatelessWidget {
  final MineController controller = Get.put(MineController());

  MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 245),
      body: Visibility(
        visible: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 260,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x00000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: color_main,
                            borderRadius:
                                BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '用户昵称',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '18',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '中国 广东',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '个性签名',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ContactItem(
                            icon: Icons.perm_device_info_outlined,
                            title: '我的设备',
                          ),
                          ContactItem(
                            icon: Icons.star,
                            title: '个人成就',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        MenuItem(
                          icon: Icons.face,
                          title: '客服反馈',
                          onPressed: () {
                            print("体验新版本  ----   >");
                          },
                        ),
                        const MenuItem(
                          icon: Icons.print,
                          title: '常见问题',
                        ),
                        const MenuItem(
                          icon: Icons.archive,
                          title: '设置',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onPressed;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SoundGestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 16.0),
                  )),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(
              color: Colors.black26,
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({
    Key? key,
    required this.icon,
    required this.title,
    this.onPressed,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SoundGestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(color: Colors.black54, fontSize: 14.0)),
        ],
      ),
    );
  }
}
