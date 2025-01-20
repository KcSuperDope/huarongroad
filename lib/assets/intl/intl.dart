import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_de.dart';
import 'package:huaroad/assets/intl/intl_en.dart';
import 'package:huaroad/assets/intl/intl_es.dart';
import 'package:huaroad/assets/intl/intl_fr.dart';
import 'package:huaroad/assets/intl/intl_hk.dart';
import 'package:huaroad/assets/intl/intl_ja.dart';
import 'package:huaroad/assets/intl/intl_zh.dart';

class Intl extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US_res,
        'zh_CN': zh_CN_res,
        'hk_CN': hk_HK_res,
        'ja_JP': ja_JP_res,
        'fr_FR': fr_FR_res,
        'es_ES': es_ES_res,
        'de_DE': de_DE_res,
      };
}
