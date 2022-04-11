import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'route.dart';
import 'service/environment.dart';

void main() {
  environment.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: const Color(0xff2d8cf0),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}
