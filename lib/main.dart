import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

import 'route.dart';
import 'service/environment.dart';
import 'style/app_theme.dart';
import 'style/constants.dart';

void main() {
  environment.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppTheme()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///不想让整个myApp都刷新
    // AppTheme appTheme = context.watch<AppTheme>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      routerDelegate: RoutemasterDelegate(
          routesBuilder: (content) => RouteMap(
                routes: routes,
              )),
      routeInformationParser: RoutemasterParser(),
      builder: (BuildContext context, Widget? child) {
        //设置字体大小不随系统设置改变
        return child!;
      },
      theme: ThemeData(
        tabBarTheme: TabBarTheme.of(context)
            .copyWith(labelStyle: TextStyle(fontFamily: 'FangZheng')),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: "FangZheng", //全局默认字体
        primaryColor: Colors.blueAccent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}
