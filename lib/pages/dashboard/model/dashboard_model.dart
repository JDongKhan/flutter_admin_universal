import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widget/universal_dashboard.dart';

///@Description TODO
///@Author jd

class DashboardModel with ChangeNotifier {
  bool openFullScreen = false;

  void openOrCloseFullScreen(BuildContext context) {
    openFullScreen = !openFullScreen;
    UniversalDashboard.of(context)?.openOrCloseLeftMenu(open: openFullScreen);
    UniversalDashboard.of(context)?.openOrCloseSetting(open: openFullScreen);
    notifyListeners();
  }
}
