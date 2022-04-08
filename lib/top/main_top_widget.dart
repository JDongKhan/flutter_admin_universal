import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

/// @author jd

class MainTopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFF5F5F5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2.0, 5.0), //阴影xy轴偏移量
            blurRadius: 15.0, //阴影模糊程度
            spreadRadius: 1.0, //阴影扩散程度
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UniversalDashboard.isMobile()
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  })
              : Container(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 20,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '站内搜索',
                  ),
                  style: TextStyle(fontSize: 10),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.query_builder_outlined,
                  size: 16,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 16,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 16,
                ),
                onPressed: () {
                  UniversalDashboard.of(context)?.openSetting();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
