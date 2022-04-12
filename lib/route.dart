import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

import 'login.dart';
import 'pages/dashboard/model/dashboard_model.dart';
import 'pages/dashboard/page/dashboard.dart' deferred as home;
import 'widget/deferred_widget.dart';

/// @author jd
///
///
final Map<String, PageBuilder> routes = {
  '/': (_) {
    return MaterialPage(
      child: Provider(
        create: (BuildContext context) => DashboardModel(),
        child: DeferredWidget(
          future: home.loadLibrary(),
          builder: () => home.DashboardPage(),
        ),
      ),
    );
  },
  '/login': (_) => MaterialPage(
        child: LoginPage(),
      ),
};
