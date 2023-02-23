import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../style/app_theme.dart';
import '../../../widget/deferred_widget.dart';
import '../../../widget/universal_dashboard.dart';
import '../../app/app_list_page.dart' deferred as app;
import '../../home/main_content_page.dart';
import '../../left_menu/left_menu_page.dart';
import '../../setting/setting_page.dart';
import '../../top_nav/main_top_widget.dart';
import '../../user/user_list_page.dart' deferred as user;
import '../../web/web_page.dart' deferred as web;
import '../../log/log_list_page.dart' deferred as log;
import '../../../pages/left_menu/model/menu_item.dart' as menu;
import '../../../pages/dept/dept_page.dart' deferred as dept;

/// @author jd

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  State createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget? _selectedPage;
  menu.MenuItem? _selectedMenuItem;
  final List<menu.MenuItem> menus = [
    menu.MenuItem.first('仪表盘', Icons.home_outlined, [
      menu.MenuItem.second(
        '首页',
        '/home',
        builder: (_) => const MainContentPage(),
      ),
      menu.MenuItem.second(
        '应用列表',
        '/app_list',
        builder: (_) => DeferredWidget(
          future: app.loadLibrary(),
          builder: () => app.AppListPage(),
        ),
      ),
      menu.MenuItem.second(
        '用户列表',
        '/user_list',
        builder: (_) => DeferredWidget(
          future: user.loadLibrary(),
          builder: () => user.UserListPage(),
        ),
      ),
    ]),
    menu.MenuItem.first('监控', Icons.report_gmailerrorred_outlined, [
      menu.MenuItem.second(
        '操作日志',
        '/log',
        builder: (_) => DeferredWidget(
          future: log.loadLibrary(),
          builder: () => log.LogPage(),
        ),
      ),
      menu.MenuItem.second(
        '外边系统',
        '/web',
        builder: (_) => DeferredWidget(
          future: web.loadLibrary(),
          builder: () => web.WebPage(
            url: 'https://flutter.cn',
          ),
        ),
      ),
    ]),
    menu.MenuItem.first('设置', Icons.settings, [
      menu.MenuItem.second(
        '部门设置',
        '/dept',
        builder: (_) => DeferredWidget(
          future: dept.loadLibrary(),
          builder: () => dept.DeptPage(),
        ),
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return UniversalDashboard(
      leftMenu: LeftMenuPage(
        items: menus,
        selectedItem: _selectedMenuItem,
        itemChanged: (menu.MenuItem item) {
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
        constraints: const BoxConstraints(minWidth: 1000),
        color: context.watch<AppTheme>().theme.bgColor,
        child: Column(
          children: [
            const MainTopWidget(),
            Expanded(
              child: _selectedPage ??
                  (menus.first.items?.first.builder?.call(context) ??
                      Container()),
            ),
          ],
        ),
      ),
      endDrawer: const SettingPage(),
    );
  }
}
