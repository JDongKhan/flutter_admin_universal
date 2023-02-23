import '/utils/login_util.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../style/app_theme.dart';
import '../../style/theme.dart';
import '../../utils/navigation_util.dart';
import '../../widget/universal_dashboard.dart';

/// @author jd

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 1,
            color: Color(0xFFF5F5F5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5.0, 2.0), //阴影xy轴偏移量
            blurRadius: 15.0, //阴影模糊程度
            spreadRadius: 1.0, //阴影扩散程度
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () {
                      UniversalDashboard.of(context)?.openOrCloseSetting();
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _showUserInfo(context);
                },
                icon: const Icon(
                  Icons.people_alt_outlined,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showThemeDialog(context);
                },
                icon: const Icon(
                  Icons.style_rounded,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.subject_outlined,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map> themeColorMap = [
    {
      'color': const Color(0xFF495060),
      'theme': MyTheme.defaultTheme(),
    },
    {
      'color': Colors.black87,
      'theme': MyTheme.black87Theme(),
    },
    {
      'color': Colors.redAccent,
      'theme': MyTheme.redAccentTheme(),
    },
    {
      'color': Colors.blueAccent,
      'theme': MyTheme.blueAccentTheme(),
    },
  ];

  Color? _selectedColor;

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '更改主题',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: themeColorMap.map((e) {
                    Color value = (e['color'] as Color);
                    return InkWell(
                      onTap: () {
                        Navigator.of(c).pop();
                        context.read<AppTheme>().changTheme(e['theme']);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        color: value,
                        child: _selectedColor == value
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUserInfo(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Dialog(
          child: SizedBox(
            width: 500,
            child: LicensePage(
              applicationName: appName,
              applicationVersion: version,
              applicationLegalese: "",
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('确认退出吗？'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(c).pop();
                },
              ),
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.of(c).pop();
                  LoginUtil.logout();
                  NavigationUtil.go("/login");
                },
              ),
            ],
          );
        });
  }
}
