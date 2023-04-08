import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../style/app_theme.dart';
import '../../style/constants.dart';
import 'model/menu_item.dart' as menu;

/// @author jd

// ignore: must_be_immutable
class LeftMenuPage extends StatelessWidget {
  LeftMenuPage({
    Key? key,
    this.itemChanged,
    this.selectedItem,
    required this.items,
  }) : super(key: key) {
    selectedItem ??= items.first.items?.first;
  }
  final ValueChanged<menu.MenuItem>? itemChanged;
  menu.MenuItem? selectedItem;
  final List<menu.MenuItem> items;

  @override
  Widget build(BuildContext context) {
    AppTheme model = context.watch<AppTheme>();
    return Container(
      width: kMenuWidth,
      padding: const EdgeInsets.only(right: 3),
      child: Container(
        decoration: BoxDecoration(
          color: model.theme.menuBackgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3.0, 0.0), //阴影xy轴偏移量
              blurRadius: 5.0, //阴影模糊程度
              spreadRadius: 1.0, //阴影扩散程度
            ),
          ],
        ),
        child: Column(
          children: [
            _topTitleWidget(model),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: items
                    .map(
                      (e) => _firstItemWidget(context, e, model),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topTitleWidget(AppTheme model) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: ScreenUtils.isMobile() ? 44 : 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/app_head.svg',
              width: 18,
              height: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '后台管理系统',
              style: TextStyle(
                color: model.theme.menuPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _firstItemWidget(
      BuildContext context, menu.MenuItem firstItem, AppTheme model) {
    int index = items.indexOf(firstItem);

    /// 更改ExpansionTile主题 可使用Theme或collapsedIconColor
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme:
            ColorScheme.light(primary: model.theme.menuPrimaryTextColor),
        unselectedWidgetColor: model.theme.menuPrimaryTextColor,
      ),
      child: ExpansionTile(
        expandedAlignment: Alignment.bottomRight,
        collapsedIconColor: model.theme.menuPrimaryTextColor,
        initiallyExpanded: index == 0 ? true : false,
        iconColor: model.theme.menuPrimaryTextColor,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.only(left: 25, right: 20),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              firstItem.iconData,
              color: model.theme.menuPrimaryTextColor,
              size: 16,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              firstItem.title ?? '',
              style: TextStyle(
                color: model.theme.menuPrimaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: firstItem.items!
            .map(
              (e) => _secondItemWidget(context, e, model),
            )
            .toList(),
      ),
    );
  }

  Widget _secondItemWidget(
      BuildContext context, menu.MenuItem secondItem, AppTheme model) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: InkWell(
        onTap: () {
          if (ScreenUtils.isMobile()) {
            Navigator.of(context).pop();
          }
          if (itemChanged != null) {
            itemChanged!(secondItem);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: selectedItem == secondItem
                ? model.theme.menuSubSelectedBackgroundColor
                : model.theme.menuSubBackgroundColor,
          ),
          child: Center(
            child: SizedBox(
              height: 30,
              child: Text(
                secondItem.title ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: selectedItem == secondItem
                      ? model.theme.menuSelectedTextColor
                      : model.theme.menuSubTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
