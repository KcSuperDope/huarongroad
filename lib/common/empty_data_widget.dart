import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/styles/styles.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 153),
          Image.asset("lib/assets/png/1.0.7/empty_data.png", width: 200, height: 200),
          const SizedBox(height: 14),
          Text(S.Norecords.tr, style: const TextStyle(fontSize: 16, color: color_main_text))
        ],
      ),
    );
  }
}
