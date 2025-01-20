import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';
import 'package:huaroad/common/app_bar.dart';
import 'package:huaroad/module/device_info/device_info_controller.dart';
import 'package:huaroad/module/device_info/device_name_edit_dialog.dart';
import 'package:huaroad/module/device_info/device_name_widget.dart';
import 'package:huaroad/styles/styles.dart';
import 'package:huaroad/util/bottom_custom_sheet.dart';
import 'package:huaroad/util/dialog_util.dart';

class DeviceInfoPage extends StatelessWidget {
  final DeviceInfoController c = Get.put(DeviceInfoController());

  DeviceInfoPage({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: S.DeviceInformation),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset("lib/assets/png/device_info_cover.png", width: 183),
                  const SizedBox(height: 16),
                  DeviceNameWidget(
                    onTapDeviceName: () {
                      BottomCustomSheet.show(
                        context: context,
                        title: S.Renamedevice.tr,
                        children: [
                          const SizedBox(height: 24),
                          Container(
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              autofocus: true,
                              maxLength: 7,
                              controller: textController,
                              decoration: const InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: color_main)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          CommonTextButton(
                            title: S.OK,
                            isBorder: false,
                            onTap: () {
                              DeviceNameHandler().customDeviceName(
                                c.deviceInfoModel.device!,
                                textController.text,
                              );
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _deviceInfoItem(S.BrandName, 'Swift Block'),
                        _deviceInfoItem(S.ProductName, "AI超感华容道"),
                        _deviceInfoItem(S.DeviceModel, 'Swift-B-0001'),
                        _firmwareInfoItem(),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 34)
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceInfoItem(String label, String value) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: color_666666,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  Widget _firmwareInfoItem() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                S.FirmwareVersion.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color_main_text),
              ),
            ),
            Expanded(
              child: Text(
                c.deviceInfoModel.softwareVersion,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: color_666666,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            Obx(() => Visibility(
                  visible: c.hasNewVersion.value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: OutlinedButton(
                      onPressed: c.onTapUpdate,
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(color: color_line)),
                        minimumSize: MaterialStateProperty.all(const Size(80, 30)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(ui_button_radius)),
                        ),
                      ),
                      child: Text(
                        S.update.tr,
                        style: const TextStyle(
                          color: color_main_text,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.3),
        )
      ],
    );
  }
}
