import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'interceptor/token_invalid_interceptor.dart';
import 'route.dart';
import 'service/environment.dart';
import 'style/app_theme.dart';
import 'style/constants.dart';

const fontFamily = 'FangZheng';

void main() {
  //https://docs.flutter.dev/development/ui/navigation/url-strategies
  // usePathUrlStrategy();
  ErrorWidget.builder = _defaultErrorWidgetBuilder;
  CrashUtils.collect(_runApp, null);
}

//打印出错误信息
Widget _defaultErrorWidgetBuilder(FlutterErrorDetails details) {
  String message =
      '${details.exception}\nSee also: https://flutter.dev/docs/testing/errors';
  final Object exception = details.exception;
  return ErrorWidget.withDetails(
      message: message, error: exception is FlutterError ? exception : null);
}

void _runApp() {
  AppInfo.init(orientations: const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => {}).whenComplete(() {
    //添加cookie
    //const ColorFilter.mode(Colors.grey, BlendMode.color),
    bool grey = false;
    String? error;
    try {
      environment.init(Environment.prd);
      Network.addInterceptor(TokenInvalidInterceptor());
    } catch (e, s) {
      error = '${e.toString()}\n ${s.toString()}';
    }
    Widget widget = MyApp();
    if (grey) {
      widget = ColorFiltered(
        colorFilter: ColorFilter.matrix(getSaturation(0.5)),
        child: widget,
      );
    }
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppTheme()),
        ],
        child: widget,
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final controller = StreamController<void>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///不想让整个myApp都刷新
    // AppTheme appTheme = context.watch<AppTheme>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      routerConfig: routes,
      supportedLocales: const <Locale>[
        Locale('en', 'US'), // 美国英语
        Locale('zh', 'CN'),
      ], // 中文简体],
      localizationsDelegates: const [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: ToastUtils.init(builder: (BuildContext context, Widget? child) {
        AppInfo.setup(context);
        //设置字体大小不随系统设置改变
        return child!;
      }),
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
        fontFamily: fontFamily, //全局默认字体
        primaryColor: Colors.blueAccent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        // useMaterial3: true,
        // colorSchemeSeed: Colors.green,
        //全局样式
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
          ),
        ),
        tabBarTheme: TabBarTheme.of(context).copyWith(
          labelStyle: const TextStyle(
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }
}

class MyApp1 extends StatelessWidget {
  final String? error;

  const MyApp1({super.key, this.error});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        error: error,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title, this.error}) : super(key: key);

  final String? error;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'title'),
      ),
      body: Center(
        child: Text(
          widget.error ?? "no error",
          style: const TextStyle(color: Colors.black87, fontSize: 22),
        ),
      ),
    );
  }
}
