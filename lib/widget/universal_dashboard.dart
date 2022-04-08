import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @author jd

class UniversalDashboard extends StatefulWidget {
  const UniversalDashboard({
    required this.leftMenu,
    required this.mainPage,
    required this.endDrawer,
  });
  final Widget leftMenu;

  final Widget mainPage;

  final Widget endDrawer;

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile() => 1.sw <= 700;

  static bool isTablet() => 1.sw <= 1200 && 1.sw > 700;

  static bool isDesktop() => 1.sw > 1200;

  static _UniversalDashboardState? of(BuildContext context) {
    _UniversalDashboardState? state =
        context.findAncestorStateOfType<_UniversalDashboardState>();
    return state;
  }

  @override
  State<UniversalDashboard> createState() => _UniversalDashboardState();
}

class _UniversalDashboardState extends State<UniversalDashboard> {
  bool _openSetting = false;
  bool _openLeftMenu = true;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void openOrCloseLeftMenu() {
    bool isMobile = UniversalDashboard.isMobile();
    if (isMobile) {
      ScaffoldState? state = _scaffoldKey.currentState;
      state?.openDrawer();
    } else {
      setState(() {
        _openLeftMenu = !_openLeftMenu;
      });
    }
  }

  void openOrCloseSetting() {
    bool isMobile = UniversalDashboard.isMobile();
    if (isMobile) {
      if (_openSetting == false) {
        ScaffoldState? state = _scaffoldKey.currentState;
        state?.openEndDrawer();
      } else {
        Navigator.of(context).pop();
      }
      _openSetting = !_openSetting;
    } else {
      setState(() {
        _openSetting = !_openSetting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    bool isMobile = UniversalDashboard.isMobile();
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? widget.leftMenu : null,
      endDrawer: isMobile ? widget.endDrawer : null,
      body: contentWidget,
    );
  }
}
