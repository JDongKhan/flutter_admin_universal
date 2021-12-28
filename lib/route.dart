import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'dashboard.dart' deferred as home;
import 'login.dart';
import 'utils/login_util.dart';
import 'widget/deferred_widget.dart';

/// @author jd
///
///
final Map<String, PageBuilder> routes = {
  '/': (_) {
    if (!LoginUtil.isLoggedIn) {
      return Redirect('/login');
    }
    return MaterialPage(
      child: DeferredWidget(
        libraryLoader: () => home.loadLibrary(),
        createWidget: (key) => home.DashboardPage(),
      ),
    );
  },
  '/login': (_) => MaterialPage(
        child: LoginPage(),
      ),
};
