import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

/// @author jd

class MainTopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
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
                child: CupertinoSearchTextField(
                  itemSize: 14,
                  prefixInsets:
                      const EdgeInsetsDirectional.fromSTEB(6, 4, 0, 4),
                  padding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                  ),
                  placeholder: '站内搜索',
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
