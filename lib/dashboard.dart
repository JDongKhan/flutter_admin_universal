import 'package:flutter/material.dart';

import 'home/main_content_page.dart';
import 'menu/left_menu_page.dart';
import 'menu/model/menu_item.dart';
import 'setting/setting_page.dart';
import 'web/web_page.dart';
import 'widget/universal_dashboard.dart';

/// @author jd

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _selectedPage = MainContentPage();

  Map<String, WidgetBuilder> pageBuilder = {
    '/home': (_) => MainContentPage(),
    '/web': (_) => WebPage(),
  };

  @override
  Widget build(BuildContext context) {
    return UniversalDashboard(
      leftMenu: LeftMenuPage(
        itemChanged: (MenuItem item) {
          WidgetBuilder widgetBuilder = pageBuilder[item.route];
          _selectedPage = widgetBuilder(context);
          setState(() {});
        },
      ),
      mainPage: _selectedPage,
      endDrawer: SettingPage(),
    );
  }
}
