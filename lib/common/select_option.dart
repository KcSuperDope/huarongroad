import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/audio_palyer.dart';
import 'package:huaroad/styles/styles.dart';

class SelectOption extends StatelessWidget {
  const SelectOption({
    Key? key,
    required this.values,
    required this.currentValue,
    this.onSelect,
    this.titleStyle,
  }) : super(key: key);
  final String currentValue;
  final List<String> values;
  final TextStyle? titleStyle;
  final void Function(String value, int index)? onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(ui_button_radius)),
              border: Border.all(color: color_line, width: 2)),
          child: Text(
            "X$currentValue",
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: color_mid_text),
          ),
        ),
        value: currentValue,
        items: values
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item + S.Speed.tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: currentValue == item ? FontWeight.w600 : FontWeight.w400,
                          color: currentValue == item ? Colors.black : color_minor_text),
                    ),
                    if (currentValue == item) Image.asset("lib/assets/png/selected.png", width: 30, height: 30),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          HRAudioPlayer().playClick();
          if (onSelect != null) {
            onSelect!(value!, values.indexOf(value));
          }
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          elevation: 8,
          offset: const Offset(-7, 0),
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble({
    Key? key,
    required this.values,
    required this.child,
    required this.icons,
    this.titleStyle,
  }) : super(key: key);

  final Widget child;
  final List<String> values;
  final List<String> icons;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: child,
        value: values.first,
        items: values
            .map((item) => DropdownMenuItem<String>(
                value: item,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset("lib/assets/png/${icons[values.indexOf(item)]}.png", width: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 16, color: color_main_text),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )))
            .toList(),
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 252,
          elevation: 24,
          offset: const Offset(-7, -10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
        ),
      ),
    );
  }
}
