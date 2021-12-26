import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// @author jd

class UniversalDashboard extends StatefulWidget {
  const UniversalDashboard({
    this.leftMenu,
    this.mainPage,
    this.endDrawer,
  });
  final Widget leftMenu;

  final Widget mainPage;

  final Widget endDrawer;

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile() => 1.sw <= 700;

  static bool isTablet() => 1.sw <= 1200 && 1.sw > 700;

  static bool isDesktop() => 1.sw > 1200;

  static _UniversalDashboardState of(BuildContext context) {
    _UniversalDashboardState state =
        context.findAncestorStateOfType<_UniversalDashboardState>();
    return state;
  }

  @override
  State<UniversalDashboard> createState() => _UniversalDashboardState();
}

class _UniversalDashboardState extends State<UniversalDashboard> {
  bool _openSetting = false;

  GlobalKey _scaffoldKey = GlobalKey();

  void openSetting() {
    bool isMobile = UniversalDashboard.isMobile();
    if (isMobile) {
      ScaffoldState state = _scaffoldKey.currentState;
      state.openEndDrawer();
    } else {
      _openSetting = true;
      setState(() {});
    }
  }

  void closeSetting() {
    bool isMobile = UniversalDashboard.isMobile();
    if (isMobile) {
      ScaffoldState state = _scaffoldKey.currentState;
      state.openEndDrawer();
    } else {
      _openSetting = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    bool isMobile = UniversalDashboard.isMobile();
    Widget contentWidget;
    if (!isMobile) {
      contentWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.leftMenu,
          Expanded(child: widget.mainPage),
          _openSetting ? widget.endDrawer : Container()
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
