import 'package:flutter/foundation.dart';

import 'theme.dart';

///@Description TODO
///@Author jd

class AppTheme with ChangeNotifier {
  MyTheme theme = MyTheme.whiteTheme();

  void changTheme(MyTheme theme) {
    debugPrint('改变主题颜色');
    this.theme = theme;
    notifyListeners();
  }
}
