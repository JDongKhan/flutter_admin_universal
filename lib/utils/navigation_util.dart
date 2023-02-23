import 'package:url_launcher/url_launcher.dart';

import '../route.dart';

/// @author jd

class NavigationUtil {
  factory NavigationUtil.getInstance() => _getInstance();
  NavigationUtil._internal();
  static NavigationUtil? _instance;
  static NavigationUtil _getInstance() {
    return _instance = _instance ?? NavigationUtil._internal();
  }

  static void push(
    String routeName, {
    Object? extra,
  }) {
    routes.push(routeName, extra: extra);
  }

  static void go(
    String routeName, {
    Object? extra,
  }) {
    routes.go(routeName, extra: extra);
  }

  static void replace(String routeName, {Object? extra}) {
    routes.replace(routeName, extra: extra);
  }

  static void back() {
    routes.pop();
  }

  static void pushWebView({
    String? title,
    required String url,
  }) {
    routes.push("/web?title=$title&url=$url");
  }

  static Future<dynamic> launchInBrowser(String url, {String? title}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      return await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
