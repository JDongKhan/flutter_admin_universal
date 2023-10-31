// @dart=2.18
// Flutter web bootstrap script for package:flutter_admin_universal/main.dart.
//
// Generated file. Do not edit.
//

// ignore_for_file: type=lint

import 'dart:ui_web' as ui_web;
import 'dart:async';

import 'package:flutter_admin_universal/main.dart' as entrypoint;
import 'web_plugin_registrant.dart' as pluginRegistrant;

typedef _UnaryFunction = dynamic Function(List<String> args);
typedef _NullaryFunction = dynamic Function();

Future<void> main() async {
  await ui_web.bootstrapEngine(
    runApp: () {
      if (entrypoint.main is _UnaryFunction) {
        return (entrypoint.main as _UnaryFunction)(<String>[]);
      }
      return (entrypoint.main as _NullaryFunction)();
    },
    registerPlugins: () {
      pluginRegistrant.registerPlugins();
    },
  );
}
