import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'pages/error/no_found_page.dart';
import 'pages/login/login.dart';
import 'pages/dashboard/model/dashboard_model.dart';
import 'pages/dashboard/page/dashboard.dart';
// import 'pages/dashboard/page/dashboard.dart' deferred as home;

/// @author jd
final routes = GoRouter(
  initialLocation: "/",
  debugLogDiagnostics: true,
  observers: [ToastUtils.observer()],
  errorBuilder: (context, state) => NotFoundPage(state.error),
  //重定向
  // redirect: (BuildContext context, GoRouterState state) {
  //   if (!LoginUtil.isLoggedIn) {
  //     return '/login';
  //   } else {
  //     return null;
  //   }
  // },
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => ChangeNotifierProvider(
    //     create: (BuildContext context) => DashboardModel(),
    //     child: DeferredWidget(
    //       future: home.loadLibrary(),
    //       builder: () => home.DashboardPage(),
    //     ),
    //   ),
    // ),
    GoRoute(
      path: '/',
      builder: (context, state) => ChangeNotifierProvider(
        create: (BuildContext context) => DashboardModel(),
        child: const DashboardPage(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
