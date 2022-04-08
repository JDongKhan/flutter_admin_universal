import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/left_menu/model/menu_item.dart';

/// @author jd

const double kMenuWidth = 150;
const Color _kMenuBackgroundColor = Color(0xFF495060);
const Color _kMenuMainTextColor = Color(0xffffffff);
const Color _kMenuTextColor = Color(0xffbcbfcb);
const Color _kMenuSelectedTextColor = Color(0xffffffff);
const Color _kMenuSubTextColor = Color(0xff999999);

const Color _kMenuSubBackgroundColor = Color(0xff363e4);

// ignore: must_be_immutable
class LeftMenuPage extends StatelessWidget {
  LeftMenuPage({
    Key? key,
    this.itemChanged,
    MenuItem? selectedItem,
    required this.items,
  }) : super(key: key) {
    selectedItem ??= items.first.items?.first;
    this.selectedItem = selectedItem;
  }
  final ValueChanged<MenuItem>? itemChanged;
  MenuItem? selectedItem;
  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kMenuWidth,
      // color: const Color(0xff000066),
      child: Drawer(
        child: Column(
          children: [
            _topTitleWidget(),
            Expanded(
              child: ListView(
                children: items
                    .map(
                      (e) => _firstItemWidget(context, e),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topTitleWidget() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      color: _kMenuBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.my_library_books,
            color: _kMenuMainTextColor,
            size: 16,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '后台管理系统',
            style: TextStyle(
              color: _kMenuMainTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstItemWidget(BuildContext context, MenuItem firstItem) {
    /// 更改ExpansionTile主题 可使用Theme或collapsedIconColor
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(primary: _kMenuMainTextColor),
        unselectedWidgetColor: _kMenuMainTextColor,
      ),
      child: ExpansionTile(
        expandedAlignment: Alignment.bottomRight,
        collapsedIconColor: _kMenuMainTextColor,
        initiallyExpanded: true,
        iconColor: _kMenuMainTextColor,
        backgroundColor: _kMenuBackgroundColor,
        collapsedBackgroundColor: _kMenuBackgroundColor,
        tilePadding: const EdgeInsets.only(left: 25, right: 20),
        title: Row(
          children: [
            Icon(
              firstItem.iconData,
              color: _kMenuMainTextColor,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              firstItem.title ?? '',
              style: TextStyle(
                color: _kMenuMainTextColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: firstItem.items!
            .map(
              (e) => _secondItemWidget(context, e),
            )
            .toList(),
      ),
    );
  }

  Widget _secondItemWidget(BuildContext context, MenuItem secondItem) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: () {
          if (itemChanged != null) {
            itemChanged!(secondItem);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: selectedItem == secondItem
                ? Theme.of(context).primaryColor
                : _kMenuSubBackgroundColor,
          ),
          child: Center(
            child: Container(
              height: 30,
              child: Text(
                secondItem.title ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: selectedItem == secondItem
                      ? _kMenuSelectedTextColor
                      : _kMenuSubTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
