// import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/info/page/user_list_page.dart';
import 'package:flutter_admin_universal/network/network_utils.dart';
import 'package:flutter_admin_universal/service/environment.dart';
import 'package:flutter_admin_universal/service/path/login_path.dart';

import 'account/account_list_page.dart';
import 'menu/left_menu_page.dart';
import 'menu/model/menu_item.dart';
import 'platform/platform_adapter.dart';
import 'setting/setting_page.dart';
import 'web/web_page.dart' deferred as web;
import 'widget/deferred_widget.dart';
import 'widget/universal_dashboard.dart';

/// @author jd

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _selectedPage = AccountListPage();

  Map<String, WidgetBuilder> pageBuilder = {
    '/home': (_) => AccountListPage(),
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
          if (UniversalDashboard.isMobile()) {
            Navigator.of(context).pop();
          }
          if (item.route == '/to_login') {
            platformAdapter.login(environment.path.loginUrl);
            return;
          }
          if (item.route == '/to_request') {
            _callRequest();
            // html.window.open('https://www.baidu.com', 'baidu');
            return;
          }
          if (item.route == '/to_cookie') {
            platformAdapter.cookies();
            return;
          }

          WidgetBuilder? widgetBuilder = pageBuilder[item.route];
          if (widgetBuilder != null) {
            _selectedPage = widgetBuilder.call(context);
            setState(() {});
          }
        },
      ),
      mainPage: _selectedPage,
      endDrawer: SettingPage(),
    );
  }

  void _callJS() {
    platformAdapter.log('haha');
  }

  void _callRequest() async {
    var res =
        await Network.get('http://zr.cnsuning.com:8081/sample/test/authAccess');
  }
}
