import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/style/app_theme.dart';
import 'package:flutter_admin_universal/style/theme.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';
import 'package:provider/provider.dart';

/// @author jd

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
        child: Container(
          width: 60,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Center(
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onPressed: () {
                      UniversalDashboard.of(context)?.openOrCloseSetting();
                    },
                  ),
                ),
                height: 60,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.people_alt_outlined,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showThemeDialog(context);
                },
                icon: Icon(
                  Icons.replay,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.subject_outlined,
                  size: 18,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
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
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                            ? Icon(
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
}
