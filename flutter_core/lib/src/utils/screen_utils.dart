import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @author jd
/*
  ScreenUtil.pixelRatio       //设备的像素密度
    ScreenUtil.screenWidth      //设备宽度
    ScreenUtil.screenHeight     //设备高度
    ScreenUtil.bottomBarHeight  //底部安全区距离，适用于全面屏下面有按键的
    ScreenUtil.statusBarHeight  //状态栏高度 刘海屏会更高  单位px
    ScreenUtil.textScaleFactor //系统字体缩放比例
    
    ScreenUtil().scaleWidth  // 实际宽度的dp与设计稿px的比例
    ScreenUtil().scaleHeight // 实际高度的dp与设计稿px的比例
*/

class ScreenUtils {
  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile() => 1.sw <= 700;

  static bool isTablet() => 1.sw <= 1200 && 1.sw > 700;

  static bool isDesktop() => 1.sw > 1200;
}

double getScreenWidth() {
  return ScreenUtil().screenWidth;
}

double getScreenHeight() {
  return ScreenUtil().screenHeight;
}

double getStatusBarHeight() {
  return ScreenUtil().statusBarHeight;
}

double getNavigationHeight() {
  return kToolbarHeight + getStatusBarHeight();
}

double getSp(double fontSize) {
  return ScreenUtil().setSp(fontSize);
}

/// 设置宽度
double getWidth(double width) {
  return ScreenUtil().setWidth(width);
}

/// 设置宽度
double getHeight(double height) {
  return ScreenUtil().setHeight(height);
}

/// 设置字体尺寸
double getFontSize(double fontSize) {
  return ScreenUtil().setSp(fontSize);
}
