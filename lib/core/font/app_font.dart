import 'package:blog_app/core/color/app_color.dart';
import 'package:flutter/material.dart';

/// Screen size helper class - Initialize once with context
class ScreenSize {
  static double _width = 0;
  static double _height = 0;
  static bool _initialized = false;

  /// Initialize screen dimensions - Call this once in your app
  static void init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _initialized = true;
  }

  static double get width => _width;
  static double get height => _height;
  static bool get initialized => _initialized;
}

class AppFonts {
  static double _getFontSize(double baseFontSize) {
    if (!ScreenSize.initialized ||
        ScreenSize.width == 0 ||
        ScreenSize.height == 0) {
      return baseFontSize;
    }
    double scaleFactor = (ScreenSize.width + ScreenSize.height) / 1800;
    return baseFontSize * scaleFactor;
  }

  // ==================== LIGHT FONTS (w300) ====================

  static TextStyle light10({Color? color}) => TextStyle(
    fontSize: _getFontSize(10.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light12({Color? color}) => TextStyle(
    fontSize: _getFontSize(12.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light14({Color? color}) => TextStyle(
    fontSize: _getFontSize(14.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light16({Color? color}) => TextStyle(
    fontSize: _getFontSize(16.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light18({Color? color}) => TextStyle(
    fontSize: _getFontSize(18.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light20({Color? color}) => TextStyle(
    fontSize: _getFontSize(20.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light24({Color? color}) => TextStyle(
    fontSize: _getFontSize(24.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light28({Color? color}) => TextStyle(
    fontSize: _getFontSize(28.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle light32({Color? color}) => TextStyle(
    fontSize: _getFontSize(32.0),
    fontWeight: FontWeight.w300,
    color: color ?? AppColors.whiteColor,
  );

  // ==================== REGULAR FONTS (w400) ====================

  static TextStyle regular10({Color? color}) => TextStyle(
    fontSize: _getFontSize(10.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular12({Color? color}) => TextStyle(
    fontSize: _getFontSize(12.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular14({Color? color}) => TextStyle(
    fontSize: _getFontSize(14.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular16({Color? color}) => TextStyle(
    fontSize: _getFontSize(16.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular18({Color? color}) => TextStyle(
    fontSize: _getFontSize(18.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular20({Color? color}) => TextStyle(
    fontSize: _getFontSize(20.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular22({Color? color}) => TextStyle(
    fontSize: _getFontSize(22.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle regular24({Color? color}) => TextStyle(
    fontSize: _getFontSize(24.0),
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.whiteColor,
  );

  // ==================== MEDIUM FONTS (w500) ====================

  static TextStyle medium10({Color? color}) => TextStyle(
    fontSize: _getFontSize(10.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium12({Color? color}) => TextStyle(
    fontSize: _getFontSize(12.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium14({Color? color}) => TextStyle(
    fontSize: _getFontSize(14.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium16({Color? color}) => TextStyle(
    fontSize: _getFontSize(16.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium18({Color? color}) => TextStyle(
    fontSize: _getFontSize(18.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium20({Color? color}) => TextStyle(
    fontSize: _getFontSize(20.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium22({Color? color}) => TextStyle(
    fontSize: _getFontSize(22.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium24({Color? color}) => TextStyle(
    fontSize: _getFontSize(24.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium26({Color? color}) => TextStyle(
    fontSize: _getFontSize(26.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium28({Color? color}) => TextStyle(
    fontSize: _getFontSize(28.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium30({Color? color}) => TextStyle(
    fontSize: _getFontSize(30.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle medium32({Color? color}) => TextStyle(
    fontSize: _getFontSize(32.0),
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.whiteColor,
  );

  // ==================== SEMI-BOLD FONTS (w600) ====================

  static TextStyle semiBold10({Color? color}) => TextStyle(
    fontSize: _getFontSize(10.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold12({Color? color}) => TextStyle(
    fontSize: _getFontSize(12.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold14({Color? color}) => TextStyle(
    fontSize: _getFontSize(14.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold16({Color? color}) => TextStyle(
    fontSize: _getFontSize(16.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold18({Color? color}) => TextStyle(
    fontSize: _getFontSize(18.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold20({Color? color}) => TextStyle(
    fontSize: _getFontSize(20.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold24({Color? color}) => TextStyle(
    fontSize: _getFontSize(24.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold28({Color? color}) => TextStyle(
    fontSize: _getFontSize(28.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle semiBold32({Color? color}) => TextStyle(
    fontSize: _getFontSize(32.0),
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.whiteColor,
  );

  // ==================== BOLD FONTS (w700) ====================

  static TextStyle bold10({Color? color}) => TextStyle(
    fontSize: _getFontSize(10.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold12({Color? color}) => TextStyle(
    fontSize: _getFontSize(12.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold14({Color? color}) => TextStyle(
    fontSize: _getFontSize(14.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold16({Color? color}) => TextStyle(
    fontSize: _getFontSize(16.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold18({Color? color}) => TextStyle(
    fontSize: _getFontSize(18.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold20({Color? color}) => TextStyle(
    fontSize: _getFontSize(20.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold22({Color? color}) => TextStyle(
    fontSize: _getFontSize(22.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold24({Color? color}) => TextStyle(
    fontSize: _getFontSize(24.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold28({Color? color}) => TextStyle(
    fontSize: _getFontSize(28.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold32({Color? color}) => TextStyle(
    fontSize: _getFontSize(32.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );

  static TextStyle bold36({Color? color}) => TextStyle(
    fontSize: _getFontSize(36.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );
  static TextStyle bold50({Color? color}) => TextStyle(
    fontSize: _getFontSize(50.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );
  static TextStyle bold58({Color? color}) => TextStyle(
    fontSize: _getFontSize(58.0),
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.whiteColor,
  );
}
