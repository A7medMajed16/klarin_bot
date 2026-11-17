import 'package:material_ui/material_ui.dart';

abstract class AppColors {
  // ─── Primary ───
  static const Color primerColor = Color(0xff242021);
  static const Color primerColorB5 = Color(0x0D242021);
  static const Color primerColorB10 = Color(0x1A242021);
  static const Color primerColorB25 = Color(0x40242021);
  static const Color primerColorB32 = Color(0x52242021);
  static const Color primerColorB60 = Color(0x99242021);

  // ─── Black & White ───
  static const Color originalBlack = Color(0xff000000);
  static const Color originalWhite = Color(0xffffffff);
  static const Color black0D = Color(0xff0D0D0D);
  static const Color black04 = Color(0xff040404);
  static const Color black27 = Color(0xff272727);
  static const Color whiteFA = Color(0xffFAFAFA);
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
  static const Color grayDB = Color(0xffDBDBDB);
  static const Color grayE4 = Color(0xffE4E4E4);
  static const Color grayF4 = Color(0xffF4F4F4);
  static const Color grayFD = Color(0xffFDFDFD);

  // ─── Semantic ───
  static const Color originalRed = Color(0xffD63131);
  static const Color redEA = Color(0xffEA3433);
  static const Color redBC = Color(0xffBC2624);
  static const Color redB4 = Color(0xffB42318);
  static const Color green17 = Color(0xff17A948);

  // ─── Accent ───
  static const Color purple97 = Color(0xff9747FF);
  static const Color purple97B10 = Color(0x1A9747FF);

  // ─── Gradients ───
  static const LinearGradient primerGradient = LinearGradient(
    colors: [redEA, redBC],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Shadows ───
  static BoxShadow shadowBox = BoxShadow(
    color: primerColor,
    blurRadius: 10,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );
}
