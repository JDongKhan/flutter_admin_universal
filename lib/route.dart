import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'dashboard.dart' deferred as home;
import 'login.dart';
import 'widget/deferred_widget.dart';

/// @author jd
///
///
final Map<String, PageBuilder> routes = {
  '/': (_) {
    return MaterialPage(
      child: DeferredWidget(
        future: home.loadLibrary(),
        builder: () => home.DashboardPage(),
      ),
    );
  },
  '/login': (_) => MaterialPage(
        child: LoginPage(),
      ),
};
