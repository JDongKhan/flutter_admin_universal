import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/menu/model/menu_item.dart';

/// @author jd

class LeftMenuPage extends StatefulWidget {
  const LeftMenuPage({
    this.itemChanged,
  });
  final ValueChanged<MenuItem> itemChanged;
  @override
  _LeftMenuPageState createState() => _LeftMenuPageState();
}

class _LeftMenuPageState extends State<LeftMenuPage> {
  final List menus = [
    MenuItem.first('仪表盘', Icons.home_outlined, [
      MenuItem.second('首页', '/home'),
      MenuItem.second('用户列表', '/user_list'),
      MenuItem.second('菜单1-3', '/web'),
      MenuItem.second('菜单1-4', '/web'),
    ]),
    MenuItem.first('异常页', Icons.report_gmailerrorred_outlined, [
      MenuItem.second('菜单2-1', '/web'),
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

  MenuItem _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      color: const Color(0xff000066),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: const Color(0xff000055),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.my_library_books,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '后台管理系统',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: menus
                  .map(
                    (e) => _firstItemWidget(e),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstItemWidget(MenuItem firstItem) {
    /// 更改ExpansionTile主题 可使用Theme或collapsedIconColor
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.white),
        unselectedWidgetColor: Colors.white,
      ),
      child: ExpansionTile(
        expandedAlignment: Alignment.bottomRight,
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        tilePadding: const EdgeInsets.only(left: 25, right: 20),
        title: Row(
          children: [
            Icon(
              firstItem.iconData,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              firstItem.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: firstItem.items
            .map(
              (e) => _secondItemWidget(e),
            )
            .toList(),
      ),
    );
  }

  Widget _secondItemWidget(MenuItem secondItem) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: () {
          _selectedItem = secondItem;
          widget.itemChanged(secondItem);
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: _selectedItem == secondItem
                ? const Color(0xffff00aa)
                : const Color(0xff000044),
          ),
          child: Center(
            child: Container(
              height: 30,
              child: Text(
                secondItem.title,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      _selectedItem == secondItem ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
