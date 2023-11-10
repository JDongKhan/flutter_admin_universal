import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';

import '../../../widget/deferred_widget.dart';
import '../../../widget/universal_dashboard.dart';
import '../../../pages/left_menu/model/menu_item.dart' as menu;
import '../../home/main_content_page.dart';
import '../../app/app_list_page.dart' deferred as app;
import '../../account/account_list_page.dart' deferred as account;
import '../../user/user_list_page.dart' deferred as user;
import '../../log/log_list_page.dart' deferred as log;
import '../../../pages/dept/dept_page.dart' deferred as dept;
import '../../../widget/webview/web_page.dart';

///@Description TODO
///@Author jd

class DashboardModel with ChangeNotifier {
  bool openFullScreen = false;

  List<menu.MenuItem> selectedMenuList = [];

  menu.MenuItem? _selectedMenuItem;
  set selectedMenuItem(v) {
    _selectedMenuItem = v;
    if (!selectedMenuList.contains(v)) {
      selectedMenuList.add(v);
    }
    notifyListeners();
  }

  menu.MenuItem? get selectedMenuItem => _selectedMenuItem;

  void init() {
    if (_selectedMenuItem == null) {
      _selectedMenuItem = menus.first.items?.first;
      selectedMenuList.add(_selectedMenuItem!);
    }
  }

  void deleteItem(menu.MenuItem item) {
    selectedMenuList.remove(item);
    if (_selectedMenuItem == item) {
      _selectedMenuItem = selectedMenuList.last;
    }
    notifyListeners();
  }

  final List<menu.MenuItem> menus = [
    menu.MenuItem.first('仪表盘', Icons.home_outlined, [
      menu.MenuItem.second(
        '首页',
        '/home',
        delete: false,
        builder: (_) => const MainContentPage(),
      ),
      menu.MenuItem.second(
        '账户列表',
        '/app_list',
        builder: (_) => DeferredWidget(
          future: account.loadLibrary(),
          builder: () => account.AccountListPage(),
        ),
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
        builder: (_) => const WebPage(
          url: 'https://flutter.cn',
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

  void openOrCloseFullScreen(BuildContext context) {
    openFullScreen = !openFullScreen;
    platformAdapter.requestFullscreen(openFullScreen);
    UniversalDashboard.of(context)?.openOrCloseLeftMenu(open: openFullScreen);
    UniversalDashboard.of(context)?.openOrCloseSetting(open: openFullScreen);
    notifyListeners();
  }
}
