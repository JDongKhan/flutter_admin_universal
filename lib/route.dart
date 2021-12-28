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
        libraryLoaderFuture: home.loadLibrary(),
        createWidget: () => home.DashboardPage(),
      ),
    );
  },
  '/login': (_) => MaterialPage(
        child: LoginPage(),
      ),
};
