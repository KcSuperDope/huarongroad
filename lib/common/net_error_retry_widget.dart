import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/styles/styles.dart';

class NetErrorRetryWidget extends StatelessWidget {
  const NetErrorRetryWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 153),
          Image.asset("lib/assets/png/tip_net_error.png", width: 200, height: 200),
          Text(S.Networkissue.tr, style: const TextStyle(fontSize: 16, color: color_main_text)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => onRetry(),
            child: Container(
              alignment: Alignment.center,
              width: 165,
              height: 40,
              decoration: const BoxDecoration(
                color: color_main,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:
                  Text(S.Refresh.tr, style: const TextStyle(color: color_main_text, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
