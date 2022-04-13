import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/pages/dashboard/model/dashboard_model.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';
import 'package:flutter_admin_universal/widget/pop_widget.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';
import 'package:provider/provider.dart';

/// @author jd

class MainTopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
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
            offset: Offset(2.0, 3.0), //阴影xy轴偏移量
            blurRadius: 5.0, //阴影模糊程度
            spreadRadius: 1.0, //阴影扩散程度
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: UniversalDashboard.isMobile() ? 44 : 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  UniversalDashboard.of(context)?.openOrCloseLeftMenu();
                },
              ),
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
                  _buildUserHead(),
                  IconButton(
                    icon: Icon(
                      context.watch<DashboardModel>().openFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      size: 16,
                    ),
                    onPressed: () {
                      context
                          .read<DashboardModel>()
                          .openOrCloseFullScreen(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      size: 16,
                    ),
                    onPressed: () {
                      _openFile();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 16,
                    ),
                    onPressed: () {
                      UniversalDashboard.of(context)?.openOrCloseSetting();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFile() async {
    platformAdapter.selectFileAndUpload();
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    //
    // if (result != null) {
    //   debugPrint('${result.files.length}');
    //   PlatformFile file = result.files.single;
    //   File srcfile = File(file.bytes!.toList(), file.name);
    //   debugPrint('${srcfile}');
    // } else {
    //   // User canceled the picker
    // }
  }

  _buildUserHead() {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _showUserMenu(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 3),
            child: Row(
              children: [
                Text(
                  'Admin',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 14),
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
                    'assets/images/3.0x/userHead.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///下拉菜单
  void _showUserMenu(BuildContext context) {
    showPopMenu(
      context: context,
      axis: Axis.vertical,
      offset: Offset(10, 5),
      builder: (c) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xffeeeeee)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2.0, 3.0), //阴影xy轴偏移量
                blurRadius: 5.0, //阴影模糊程度
                spreadRadius: 1.0, //阴影扩散程度
              ),
            ]),
        width: 80,
        child: Column(
          children: [
            TextButton(
              child: Text('退出'),
              onPressed: () {
                Navigator.of(c).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
