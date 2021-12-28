import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/info/page/user_list_page.dart';

import 'home/main_content_page.dart';
import 'menu/left_menu_page.dart';
import 'menu/model/menu_item.dart';
import 'setting/setting_page.dart';
import 'web/web_page.dart' deferred as web;
import 'widget/deferred_widget.dart';
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
    '/web': (_) => DeferredWidget(
          libraryLoader: () => web.loadLibrary(),
          createWidget: () => web.WebPage(),
        ),
    '/user_list': (_) => UserListPage(),
  };

  @override
  Widget build(BuildContext context) {
    return UniversalDashboard(
      leftMenu: LeftMenuPage(
        itemChanged: (MenuItem item) {
          WidgetBuilder? widgetBuilder = pageBuilder[item.route];
          _selectedPage = widgetBuilder!(context);
          setState(() {});
        },
      ),
      mainPage: _selectedPage,
      endDrawer: SettingPage(),
    );
  }
}
