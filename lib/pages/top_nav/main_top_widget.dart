import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:provider/provider.dart';
import '../../../pages/left_menu/model/menu_item.dart' as menu;
import '/http/user_service.dart';
import '/utils/login_util.dart';
import '../../http/model/user.dart';
import '../../utils/navigation_util.dart';
import '../../widget/universal_dashboard.dart';
import '../dashboard/model/dashboard_model.dart';
import '../notification/notification_page.dart';

/// @author jd

class MainTopWidget extends StatelessWidget {
  final List<menu.MenuItem>? selectedMenuList;
  final menu.MenuItem? selectedMenuItem;
  const MainTopWidget({
    super.key,
    this.selectedMenuList,
    this.selectedMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    List<menu.MenuItem> selectedMenuList = this.selectedMenuList ?? [];
    bool hasMenu = selectedMenuList.isNotEmpty;
    return Container(
      margin: EdgeInsets.only(left: ScreenUtils.isMobile() ? 0 : 6, bottom: 3),
      decoration: const BoxDecoration(
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
            offset: Offset(2.0, 3.0), //阴影xy轴偏移量
            blurRadius: 5.0, //阴影模糊程度
            spreadRadius: 1.0, //阴影扩散程度
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtils.isMobile() ? 44 : 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      UniversalDashboard.of(context)?.openOrCloseLeftMenu();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: '站内搜索',
                                contentPadding: EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 10),
                              ),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          _buildUserHead(),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 16,
                            ),
                            onPressed: () {
                              _showNotificationPage(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              context.watch<DashboardModel>().openFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                              size: 16,
                            ),
                            onPressed: () {
                              context.read<DashboardModel>().openOrCloseFullScreen(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              size: 16,
                            ),
                            onPressed: () {
                              UniversalDashboard.of(context)?.openOrCloseSetting();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (hasMenu)
              const Divider(
                height: 1,
                thickness: 1,
              ),
            if (hasMenu)
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: selectedMenuList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextButton(
                        onPressed: () {
                          DashboardModel model = context.read<DashboardModel>();
                          model.selectedMenuItem = e;
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: selectedMenuItem == e ? Colors.white : Colors.blue,
                          backgroundColor: selectedMenuItem == e ? Colors.blue : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          textStyle: const TextStyle(fontSize: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                            side: BorderSide(color: selectedMenuItem == e ? const Color(0x00000000) : Colors.black.withAlpha(100), width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(e.title ?? ''),
                            if (e.delete)
                              GestureDetector(
                                child: const Icon(Icons.close, size: 12),
                                onTap: () {
                                  DashboardModel model = context.read<DashboardModel>();
                                  model.deleteItem(e);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  //
  // void _openFile() async {
  //   platformAdapter.selectFileAndUpload();
  //   // FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   //
  //   // if (result != null) {
  //   //   debugPrint('${result.files.length}');
  //   //   PlatformFile file = result.files.single;
  //   //   File srcfile = File(file.bytes!.toList(), file.name);
  //   //   debugPrint('${srcfile}');
  //   // } else {
  //   //   // User canceled the picker
  //   // }
  // }

  void _fetchUserById(int? id) {
    if (id == null) {
      return;
    }
    UserService.queryById(id);
  }

  _buildUserHead() {
    User? user = LoginUtil.getUserInfo();
    _fetchUserById(user?.id);
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _showUserMenu(context);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 3),
              child: Row(
                children: [
                  Text(
                    user?.name ?? '',
                    style: const TextStyle(color: Colors.lightBlue, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/images/3.0x/user_head.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///下拉菜单
  void _showUserMenu(BuildContext context) {
    showContextMenu(
      context: context,
      position: Position.belowRight,
      offset: const Offset(-30, 5),
      builder: (c) => SizedBox(
        width: 80,
        child: Column(
          children: [
            TextButton(
              child: const Text('退出'),
              onPressed: () {
                Navigator.of(c).pop();
                _logoutAction(c);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationPage(BuildContext context) {
    showModalRightSheet(
      context: context,
      builder: (c) {
        return const NotificationPage();
      },
    );
  }

  ///退出登录
  void _logoutAction(BuildContext context) {
    UserService.logout().then((value) {
      NavigationUtil.go("/login");
    }).catchError((error) {
      ToastUtils.toastError(error);
    });
  }
}
