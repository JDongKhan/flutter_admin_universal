import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

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
                onPressed: () {},
                icon: Icon(
                  Icons.my_library_books,
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
}
