import 'package:material_ui/material_ui.dart';

abstract class AppColors {
  // ─── Design tokens ───
  static const Color foreground = Color(0xff303841);
  static const Color onForeground = Color(0xffffffff);
  static const Color muted = Color(0xB83A4750);
  static const Color background = Color(0xffffffff);
  static const Color surface = Color(0xffF3F3F3);
  static const Color accent = Color(0xff2185D5);
  static const Color accentB10 = Color(0x1A2185D5);
  static const Color accentB25 = Color(0x402185D5);
  static const Color accentB32 = Color(0x522185D5);
  static const Color onAccent = Color(0xffffffff);

  // ─── Hard shadows ───
  static const List<BoxShadow> brutalShadow = [
    BoxShadow(color: foreground, offset: Offset(4, 4)),
  ];
  static const List<BoxShadow> brutalShadowSm = [
    BoxShadow(color: foreground, offset: Offset(2, 2)),
  ];

  // ─── Black & White ───
  static const Color originalBlack = Color(0xff000000);
  static const Color originalWhite = Color(0xffffffff);
  static const Color black0D = Color(0xff0D0D0D);
  static const Color black04 = Color(0xff040404);
  static const Color black27 = Color(0xff272727);
  static const Color whitE5 = Color(0xffE5E5E5);

  // ─── Grays ───
  static const Color gray38 = Color(0xff383838);
  static const Color gray3F = Color(0xff3F3F3F);
  static const Color gray52 = Color(0xff525252);
  static const Color gray6C = Color(0xff6C6C6C);
  static const Color gray71 = Color(0xff717171);
  static const Color gray9D = Color(0xff9D9D9D);
  static const Color gray99 = Color(0xff999999);
  static const Color grayB6 = Color(0xffB6B6B6);
  static const Color grayE4 = Color(0xffE4E4E4);
  static const Color grayF4 = Color(0xffF4F4F4);
  static const Color grayFD = Color(0xffFDFDFD);

  // ─── Semantic ───
  static const Color originalRed = Color(0xffD63131);
  static const Color redB4 = Color(0xffB42318);
  static const Color green17 = Color(0xff17A948);
}
