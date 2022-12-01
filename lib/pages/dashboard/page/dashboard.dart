import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/network/network_utils.dart';
import 'package:flutter_admin_universal/style/app_theme.dart';
import 'package:flutter_admin_universal/widget/deferred_widget.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../platform/platform_adapter.dart';
import '../../account/account_list_page.dart' deferred as account;
import '../../home/main_content_page.dart';
import '../../left_menu/left_menu_page.dart';
import '../../left_menu/model/menu_item.dart';
import '../../setting/setting_page.dart';
import '../../top_nav/main_top_widget.dart';
import '../../user/user_list_page.dart' deferred as user;
import '../../web/web_page.dart' deferred as web;

/// @author jd

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget? _selectedPage;
  MenuItem? _selectedMenuItem;
  final List<MenuItem> menus = [
    MenuItem.first('仪表盘', Icons.home_outlined, [
      MenuItem.second(
        '首页',
        '/home',
        builder: (_) => MainContentPage(),
      ),
      MenuItem.second(
        '用户列表',
        '/user_list',
        builder: (_) => DeferredWidget(
          future: user.loadLibrary(),
          builder: () => user.UserListPage(),
        ),
      ),
      MenuItem.second(
        'Account',
        '/account',
        builder: (_) => DeferredWidget(
          future: account.loadLibrary(),
          builder: () => account.AccountListPage(),
        ),
      ),
      MenuItem.second('登录', '/to_login'),
      MenuItem.second('请求', '/to_request'),
      MenuItem.second('cookie', '/to_cookie'),
    ]),
    MenuItem.first('异常页', Icons.report_gmailerrorred_outlined, [
      MenuItem.second(
        '菜单2-1',
        '/web',
        builder: (_) => DeferredWidget(
          future: web.loadLibrary(),
          builder: () => web.WebPage(),
        ),
      ),
      MenuItem.second('菜单2-2', '/web'),
      MenuItem.second('菜单2-3', '/web'),
      MenuItem.second('菜单2-4', '/web'),
    ]),
    MenuItem.first('设置', Icons.settings, [
      MenuItem.second('菜单3-1', '/web'),
      MenuItem.second('菜单3-2', '/web'),
      MenuItem.second('菜单3-3', '/web'),
      MenuItem.second('菜单3-4', '/web'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return UniversalDashboard(
      leftMenu: LeftMenuPage(
        items: menus,
        selectedItem: _selectedMenuItem,
        itemChanged: (MenuItem item) {
          _selectedMenuItem = item;
          // if (item.route == '/to_login') {
          //   platformAdapter.login(environment.path.loginUrl);
          //   return;
          // }
          // if (item.route == '/to_request') {
          //   _callRequest();
          //   // html.window.open('https://www.baidu.com', 'baidu');
          //   return;
          // }
          // if (item.route == '/to_cookie') {
          //   platformAdapter.cookies();
          //   return;
          // }

          WidgetBuilder? widgetBuilder = item.builder;
          if (widgetBuilder != null) {
            _selectedPage = widgetBuilder.call(context);
          } else {
            _selectedPage = Container();
          }
          setState(() {});
        },
      ),
      mainPage: Container(
        constraints: BoxConstraints(minWidth: 1000),
        color: context.watch<AppTheme>().theme.bgColor,
        child: Column(
          children: [
            MainTopWidget(),
            Expanded(
              child: _selectedPage ??
                  (menus.first.items?.first?.builder?.call(context) ??
                      Container()),
            ),
          ],
        ),
      ),
      endDrawer: SettingPage(),
    );
  }

  void _callJS() {
    platformAdapter.log('haha');
  }

  void _callRequest() async {
    var res =
        await Network.get('http://zr.xx.com:8081/sample/test/authAccess');
  }
}
