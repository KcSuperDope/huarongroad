// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const ui_page_padding = 16.0;
const ui_board_padding = 7.0;
const ui_font_button_title = 18.0;
const ui_font_appbar_title = 22.0;
const ui_border_radius = 31.0;
const ui_button_radius = 12.0;

const color_main = Color(0xFFE1F035);
const color_main_text = Color(0xFF333333);
const color_mid_text = Color(0xFF666666);
const color_line = Color(0xFFEEEEEE);
const color_minor_text = Color(0xFF999999);
const color_bg = Color(0xFFF6F6F6);
const color_main_bg = Color(0xFFFCFEEB);

const color_piece_green = Color.fromRGBO(219, 241, 41, 1);
const color_piece_black = Color.fromRGBO(35, 41, 33, 1);
const color_gray_1 = Color.fromRGBO(227, 226, 218, 1);
const color_gray_2 = Color.fromRGBO(240, 243, 215, 1);

const color_bg_level_num = Color.fromRGBO(253, 235, 210, 1);
const color_bg_board = Color.fromRGBO(229, 233, 237, 1);

const color_DDE3E7 = Color(0xFFDDE3E7);
const color_E9EDEF = Color(0xFFE9EDEF);
const color_E7E7E7 = Color(0xFFE7E7E7);
const color_E5EBEE = Color(0xFFE5EBEE);
const color_9A9A9A = Color(0xff9A9A9A);
const color_CCCCCC = Color(0xffCCCCCC);
const color_EEEEEE = Color(0xffEEEEEE);
const color_D6D6D6 = Color(0xffD6D6D6);
const color_9CBD00 = Color(0xff9CBD00);
const color_D1DADF = Color(0xffD1DADF);
const color_5AD6BE = Color(0xff5AD6BE);
const color_FFFFFF = Color(0xFFFFFFFF);
const color_F6F6F6 = Color(0xFFF6F6F6);
const color_FFF06C = Color(0xFFFFF06C);
const color_FF9126 = Color(0xFFFF9126);
const color_666666 = Color(0xFF666666);
const color_FAFDE1 = Color(0xFFFAFDE1);
const color_F13C3C = Color(0xFFF13C3C);
const color_F7FFA1 = Color(0xFFF7FFA1);
const color_27F22F = Color(0xFF27F22F);
const color_E4B1A4 = Color(0xFFE4B1A4);
const color_B0CDD4 = Color(0xFFB0CDD4);
const color_FBDB68 = Color(0xFFFBDB68);
const color_60B3FF = Color(0xFF60B3FF);
const color_FFEDED = Color(0xFFFFEDED);

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;
  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };
  return MaterialColor(color.value, shades);
}

const boardTitleImageDecoration = DecorationImage(
  image: ExactAssetImage("lib/assets/png/board_title.png"),
  fit: BoxFit.fill,
);
