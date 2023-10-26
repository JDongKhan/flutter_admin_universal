import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../style/app_theme.dart';
import '../../../widget/universal_dashboard.dart';
import '../../../pages/left_menu/model/menu_item.dart' as menu;
import '../../left_menu/left_menu_page.dart';
import '../../setting/setting_page.dart';
import '../../top_nav/main_top_widget.dart';
import '../model/dashboard_model.dart';

/// @author jd

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  State createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    DashboardModel model = context.watch<DashboardModel>();
    model.init();
    List<menu.MenuItem> menus = model.menus;
    menu.MenuItem selectedMenuItem = model.selectedMenuItem!;
    Widget content = selectedMenuItem.buildWidget(context);
    return UniversalDashboard(
      leftMenu: LeftMenuPage(
        items: menus,
        selectedItem: selectedMenuItem,
        itemChanged: (menu.MenuItem item) {
          model.selectedMenuItem = item;
        },
      ),
      mainPage: Container(
        constraints: const BoxConstraints(minWidth: 1000),
        color: context.watch<AppTheme>().theme.bgColor,
        child: Column(
          children: [
            MainTopWidget(selectedMenuList: model.selectedMenuList, selectedMenuItem: model.selectedMenuItem),
            Expanded(child: content),
          ],
        ),
      ),
      endDrawer: const SettingPage(),
    );
  }
}
