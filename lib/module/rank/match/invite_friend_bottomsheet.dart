import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/common/sound_gesture_detector.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/module/rank/match/friend_model.dart';
import 'package:huaroad/module/rank/match/rank_match_controller.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/dialog_util.dart';

class InviteFriendBottomSheet extends StatelessWidget {
  final inviting = false.obs;
  final RankMatchController _rankMatchController = Get.find<RankMatchController>();
  InviteFriendBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: color_FFFFFF,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 52.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            S.Invitation.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SoundGestureDetector(
                          onTap: () {
                            if (inviting.value) {
                              DialogUtils.showAlert(
                                title: S.friendInviting,
                                content: S.interruptinvitation,
                                onTapRight: () {
                                  _rankMatchController.leftRoom();
                                  Get.back();
                                },
                              );
                            } else {
                              Get.back();
                            }
                          },
                          child: Image.asset("lib/assets/png/close.png", width: 24, height: 24),
                        ),
                      ],
                    ),
                  ),
                  Container(width: Get.width, height: 1, color: color_line),
                ],
              ),
              Expanded(
                child: Obx(() => _rankMatchController.friends.isEmpty
                    ? _emptyView()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _rankMatchController.friends.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _itemWidget(_rankMatchController.friends[index]))),
              ),
            ],
          ),
        ));
  }

  Widget _itemWidget(FriendModel item) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          height: 74,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              item.avatar != null && item.avatar != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        item.avatar ?? '',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                            'lib/assets/png/rank/rank_avatar.png',
                            width: 50,
                            height: 50),
                      ))
                  : Image.asset('lib/assets/png/rank/rank_avatar.png', width: 50, height: 50),
              const SizedBox(width: 9),
              Text(
                item.nickName ?? 'name',
                style: const TextStyle(
                    color: color_main_text, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.center,
                width: 80,
                child: Obx(() => item.inviting.value
                    ? Text(
                        S.Inviting.tr + '${item.count.value}s',
                        style: const TextStyle(
                            color: color_main_text, fontSize: 13.0, fontWeight: FontWeight.normal),
                      )
                    : FilledButton(
                        onPressed: () {
                          _rankMatchController.inviteFriend(item.userId.toString());
                          item.inviting.value = true;
                          inviting.value = true;
                          item.count.value = 30;
                          Timer.periodic(1.seconds, (timer) {
                            if (item.count.value == 0) {
                              timer.cancel();
                              item.inviting.value = false;
                              inviting.value = false;
                            }
                            item.count.value--;
                          });
                        },
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(const Size(80, 30)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            backgroundColor: MaterialStateProperty.all(color_main)),
                        child: Text(S.Invite.tr,
                            style: const TextStyle(
                                color: color_main_text,
                                fontSize: 13,
                                fontWeight: FontWeight.normal)),
                      )),
              )
            ],
          ),
        ),
        Container(width: Get.width - 16.0, height: 1, color: color_line),
      ],
    );
  }

  Widget _emptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('lib/assets/png/rank/rank_no_friends.png', width: 200, height: 200),
        const SizedBox(height: 12),
        Text(S.Nofriends.tr,
            style: const TextStyle(
                color: color_main_text, fontSize: 16, fontWeight: FontWeight.normal))
      ],
    );
  }
}

class UserInfoBottomSheet extends StatelessWidget {
  final inviting = false.obs;
  final RankMatchController _rankMatchController = Get.find<RankMatchController>();
  UserInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.max,
        children: [
          _titleView(),
          _thisWeekData(),
          const SizedBox(height: 34),
          if (_rankMatchController.userBattleInfoModel?.relationType != 2) _addFriendButton(),
        ],
      ),
    );
  }

  Widget _titleView() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Image.asset('lib/assets/png/rank/rank_user_bg.png'),
        Positioned(
          left: 30,
          top: 20,
          child: Row(
            children: [
              Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: color_main,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 2)),
                  child: _rankMatchController.userBattleInfoModel != null &&
                          _rankMatchController.userBattleInfoModel!.avatar != null &&
                          _rankMatchController.userBattleInfoModel!.avatar != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(_rankMatchController.userBattleInfoModel!.avatar!,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                  'lib/assets/png/rank/rank_avatar.png',
                                  width: 60,
                                  height: 60)))
                      : Image.asset('lib/assets/png/rank/rank_avatar.png', width: 60, height: 60)),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _rankMatchController.userBattleInfoModel?.name ?? '用户昵称',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: color_main_text,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (_rankMatchController.userBattleInfoModel?.relationType == 2)
                        Container(
                          decoration: BoxDecoration(
                              color: color_FF9126, borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          child: Text(
                            S.Invitation.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: color_60B3FF, borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              _rankMatchController.userBattleInfoModel?.sex == 2
                                  ? 'lib/assets/png/rank/rank_icon_girl.png'
                                  : 'lib/assets/png/rank/rank_icon_boy.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _rankMatchController.userBattleInfoModel?.birthday != null
                                  ? '${DateTime.now().year - int.parse(_rankMatchController.userBattleInfoModel?.birthday?.substring(0, 4) ?? '')}'
                                  : '7',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                            borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              'lib/assets/png/rank/rank_icon_local.png',
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${_rankMatchController.userBattleInfoModel?.country ?? S.Unknownlocation.tr} ${_rankMatchController.userBattleInfoModel?.province ?? ''} ${_rankMatchController.userBattleInfoModel?.city ?? ''}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: color_main_text,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 17,
          top: 12,
          child: SoundGestureDetector(
            onTap: () => Get.back(),
            child: Image.asset("lib/assets/png/close.png", width: 24, height: 24),
          ),
        ),
      ],
    );
  }

  Widget _thisWeekData() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color_F6F6F6, borderRadius: BorderRadius.circular(8)),
          child: Text(
            _rankMatchController.currentHard.value.tr,
            style: const TextStyle(
              color: color_main_text,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '${_rankMatchController.userBattleInfoModel?.weekTotalBattleWinNum ?? 1}',
                  style: const TextStyle(
                    color: color_main_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    fontFamily: "VonwaonBitmap",
                    shadows: [
                      Shadow(color: color_main, offset: Offset(2, 2), blurRadius: 0),
                    ],
                  ),
                ),
                Text(
                  S.Numberofvictories.tr,
                  style: const TextStyle(
                    color: color_mid_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 24,
              width: 1,
              color: color_F6F6F6,
            ),
            Column(
              children: [
                Text(
                  '${((_rankMatchController.userBattleInfoModel?.weekTotalBattleWinNum ?? 1) / (_rankMatchController.userBattleInfoModel?.weekTotalBattleNum ?? 2) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: color_main_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    fontFamily: "VonwaonBitmap",
                    shadows: [
                      Shadow(color: color_main, offset: Offset(2, 2), blurRadius: 0),
                    ],
                  ),
                ),
                Text(
                  S.Winrate.tr,
                  style: const TextStyle(
                    color: color_mid_text,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _addFriendButton() {
    return Column(
      children: [
        SoundGestureDetector(
          onTap: _rankMatchController.onTapAddFriend,
          child: Obx(() => _rankMatchController.hasAddFriend.value
              ? Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.8,
                  height: 48,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/png/rank/rank_button_grey_big.png'),
                          fit: BoxFit.fill)),
                  child: Text(
                    S.Applied.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFFABABAB),
                        height: 1.0),
                  ))
              : Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.8,
                  height: 48,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/png/rank/rank_button_yellow_big.png'),
                          fit: BoxFit.fill)),
                  child: Text(
                    S.Follow.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: color_main_text,
                        height: 1.0),
                  ))),
        ),
      ],
    );
  }
}
