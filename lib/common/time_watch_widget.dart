import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeWatchWidget extends StatelessWidget {
  const TimeWatchWidget({Key? key, required this.timer}) : super(key: key);
  final RxString timer;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              timer.value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w400,
                fontFamily: "BebasNeue",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
