import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';

/// @author jd

class UniversalDashboard extends StatefulWidget {
  const UniversalDashboard({
    super.key,
    required this.leftMenu,
    required this.mainPage,
    required this.endDrawer,
  });
  final Widget leftMenu;

  final Widget mainPage;

  final Widget endDrawer;

  static UniversalDashboardState? of(BuildContext context) {
    UniversalDashboardState? state =
        context.findAncestorStateOfType<UniversalDashboardState>();
    return state;
  }

  @override
  State<UniversalDashboard> createState() => UniversalDashboardState();
}

class UniversalDashboardState extends State<UniversalDashboard> {
  bool _openSetting = false;
  bool _openLeftMenu = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void openOrCloseLeftMenu({bool? open}) {
    bool isMobile = ScreenUtils.isMobile();
    if (isMobile) {
      ScaffoldState? state = _scaffoldKey.currentState;
      if (state?.isDrawerOpen ?? false) {
        Navigator.of(context).pop();
      } else {
        state?.openDrawer();
      }
    } else {
      if (open != null) {
        setState(() {
          _openLeftMenu = open;
        });
      } else {
        setState(() {
          _openLeftMenu = !_openLeftMenu;
        });
      }
    }
  }

  void openOrCloseSetting({bool? open}) {
    bool isMobile = ScreenUtils.isMobile();
    if (isMobile) {
      ScaffoldState? state = _scaffoldKey.currentState;
      if (state?.isEndDrawerOpen ?? false) {
        Navigator.of(context).pop();
      } else {
        state?.openEndDrawer();
      }
    } else {
      if (open != null) {
        setState(() {
          _openSetting = open;
        });
      } else {
        setState(() {
          _openSetting = !_openSetting;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO 不加此句 窗口变化时该widget不会刷新
    MediaQuery.of(context);
    // List<Widget> rows = [];
    bool isMobile = ScreenUtils.isMobile();
    Widget contentWidget;
    debugPrint('UniversalDashboard build: [isMobile:$isMobile]');
    if (!isMobile) {
      contentWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_openLeftMenu) widget.leftMenu,
          Expanded(child: widget.mainPage),
          if (_openSetting) widget.endDrawer,
        ],
      );
    } else {
      contentWidget = widget.mainPage;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: isMobile ? widget.leftMenu : null,
        endDrawer: isMobile ? widget.endDrawer : null,
        body: contentWidget,
      ),
    );
  }
}
