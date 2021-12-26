import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'dashboard.dart';
import 'login.dart';
import 'utils/login_util.dart';

/// @author jd
///
///
final Map<String, PageBuilder> routes = {
  '/': (_) {
    if (!LoginUtil.isLoggedIn) {
      return Redirect('/login');
    }
    return MaterialPage(
      child: DashboardPage(),
    );
  },
  '/login': (_) => MaterialPage(
        child: LoginPage(),
      ),
};
