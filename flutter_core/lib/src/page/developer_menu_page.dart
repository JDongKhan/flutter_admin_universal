import 'package:flutter/material.dart';
import '../logger/ui/log_console_page.dart';
import 'float_menu_controller.dart';
import 'setting_proxy/setting_proxy_page.dart';

/// @author jd

class DeveloperMenuPage extends StatefulWidget {
  const DeveloperMenuPage({Key? key}) : super(key: key);

  @override
  State createState() => _DeveloperMenuPageState();
}

class _DeveloperMenuPageState extends State<DeveloperMenuPage> {
  final List _menuList = [
    {
      'title': '代理设置',
      'subtitle': '设置代理服务器的ip和端口',
      'icon': Icons.phonelink_rounded,
      'click': (context) => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingProxyPage()))
          }
    },
  ];

  final Map _logConfig = {
    'title': '日志',
    'subtitle': '查看flutter相关日志',
    'icon': Icons.insert_drive_file,
    'click': (context) => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LogConsolePage()))
        },
  };

  late List _allList;

  @override
  void initState() {
    floatMenuController.addListener(_refreshUI);
    super.initState();
  }

  void _refreshUI() {
    setState(() {});
  }

  @override
  void dispose() {
    floatMenuController.removeListener(_refreshUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _allList = [];
    _allList.addAll(_menuList);
    if (floatMenuController.isShow) {
      _allList.add(_logConfig);
    }
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          title: const Text('Debug 菜单'),
          actions: [
            TextButton(
              onPressed: () {
                floatMenuController.show(context);
              },
              child: const Text('悬浮菜单(日志)'),
            ),
          ]),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          Map e = _allList[index];
          return Card(
            child: ListTile(
              minLeadingWidth: 20,
              dense: true,
              leading: Icon(
                e['icon'] as IconData,
              ),
              title: Text(
                e['title'].toString(),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              subtitle: Text(e['subtitle']),
              // contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              onTap: () {
                _onClick(e['click'] as Function?, context);
              },
            ),
          );
        },
        itemCount: _allList.length,
      ),
    );
  }

  void _onClick(Function? click, BuildContext context) {
    if (click != null) {
      click.call(context);
    }
  }
}
