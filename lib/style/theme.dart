import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

class MyTheme {
  ///主色调
  final Color primaryColor;

  ///次色调
  final Color secondaryColor;

  ///背景
  final Color bgColor;

  ///主文字颜色
  final Color primaryTextColor;

  ///副标题文字颜色
  final Color secondaryTextColor;

  ///菜单背景色
  final Color menuBackgroundColor;

  ///菜单文本色
  final Color menuPrimaryTextColor;

  ///菜单选中文本颜色
  final Color menuSelectedTextColor;

  ///菜单副文本颜色
  final Color menuSubTextColor;

  ///菜单副文本背景色
  final Color menuSubBackgroundColor;

  ///选中颜色
  final Color menuSubSelectedBackgroundColor;

  MyTheme.defaultTheme({
    this.primaryColor = const Color(0xFF495060),
    this.secondaryColor = Colors.white,
    this.bgColor = const Color(0xfff0f0f0),
    this.primaryTextColor = Colors.black87,
    this.secondaryTextColor = Colors.black54,
    this.menuBackgroundColor = const Color(0xFF495060),
    this.menuPrimaryTextColor = Colors.white,
    this.menuSelectedTextColor = Colors.white,
    this.menuSubTextColor = const Color(0xff999999),
    this.menuSubBackgroundColor = const Color(0xff363e40),
    this.menuSubSelectedBackgroundColor = Colors.blueAccent,
  });

  MyTheme.black87Theme({
    this.primaryColor = Colors.black87,
    this.secondaryColor = Colors.white,
    this.bgColor = const Color(0xfff0f0f0),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.black54,
    this.menuBackgroundColor = Colors.black87,
    this.menuPrimaryTextColor = Colors.white,
    this.menuSelectedTextColor = Colors.white,
    this.menuSubTextColor = const Color(0xff999999),
    this.menuSubBackgroundColor = Colors.black54,
    this.menuSubSelectedBackgroundColor = Colors.blueAccent,
  });

  MyTheme.redAccentTheme({
    this.primaryColor = Colors.redAccent,
    this.secondaryColor = Colors.white,
    this.bgColor = const Color(0xfff0f0f0),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.black54,
    this.menuBackgroundColor = Colors.redAccent,
    this.menuPrimaryTextColor = Colors.white,
    this.menuSelectedTextColor = Colors.white,
    this.menuSubTextColor = const Color(0xff999999),
    this.menuSubBackgroundColor = Colors.deepOrangeAccent,
    this.menuSubSelectedBackgroundColor = Colors.blueAccent,
  });

  MyTheme.blueAccentTheme({
    this.primaryColor = Colors.blueAccent,
    this.secondaryColor = Colors.white,
    this.bgColor = const Color(0xfff0f0f0),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.black54,
    this.menuBackgroundColor = Colors.blueAccent,
    this.menuPrimaryTextColor = Colors.white,
    this.menuSelectedTextColor = Colors.white,
    this.menuSubTextColor = const Color(0xffeeeeee),
    this.menuSubBackgroundColor = Colors.cyan,
    this.menuSubSelectedBackgroundColor = Colors.orangeAccent,
  });

  MyTheme.whiteTheme({
    this.primaryColor = Colors.blueAccent,
    this.secondaryColor = Colors.white,
    this.bgColor = const Color(0xfff0f0f0),
    this.primaryTextColor = Colors.white,
    this.secondaryTextColor = Colors.black54,
    this.menuBackgroundColor = Colors.white,
    this.menuPrimaryTextColor = Colors.black,
    this.menuSelectedTextColor = Colors.grey,
    this.menuSubTextColor = const Color(0xff666666),
    this.menuSubBackgroundColor = Colors.white,
    this.menuSubSelectedBackgroundColor = const Color(0xFFF5F5F5),
  });
}
