import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'platform_logger_output.dart';

/// @author jd
///
/// 日志工具
// var logger = Logger(
//   printer: PrettyPrinter(
//     methodCount: 1,
//     printTime: true,
//     colors: false,
//     // printEmojis: false,
//   ),
//   output: UIAndConsoleOutput.instance,
// );

// ignore: non_constant_identifier_names
var logger = Logger(
  level: Level.info,
  filter: PlatformFilter(),
  output: LogOutputManager.getInstance(),
  printer: PrinterLogManager.getInstance(),
);

class PlatformFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = true;
    if (kReleaseMode) {
      if (event.level.index < level!.index) {
        shouldLog = false;
      }
    }
    return shouldLog;
  }
}

///自定义日志格式
class PrinterLogManager extends PrettyPrinter {
  PrinterLogManager._internal()
      : _customLogPrinter = false,
        super(colors: false, printTime: true, stackTraceBeginIndex: 2);
  static final _instance = PrinterLogManager._internal();
  static PrinterLogManager getInstance() {
    return _instance;
  }

  bool _customLogPrinter;

  void openCustomLogPrinter() {
    _customLogPrinter = true;
  }

  // final int stackTraceBeginIndex = 1;
  // final int methodCount = 2;
  // final int errorMethodCount = 8;

  @override
  List<String> log(LogEvent event) {
    if (!_customLogPrinter) {
      return super.log(event);
    }
    var messageStr = stringifyMessage(event.message);

    String? stackTraceStr = '';
    if (event.stackTrace == null) {
      if (methodCount > 0) {
        stackTraceStr = formatStackTrace(StackTrace.current, methodCount);
      }
    } else if (errorMethodCount > 0) {
      stackTraceStr = formatStackTrace(event.stackTrace, errorMethodCount);
    }

    // var errorStr = event_list.error?.toString();

    String timeStr = getTime(DateTime.now());
    return [
      '$timeStr(${event.level})\n${stackTraceStr!}\n【$messageStr】\n',
    ];
  }
}

///日志管理器
class LogOutputManager extends LogOutput {
  LogOutputManager._internal();
  static final _instance = LogOutputManager._internal();
  static LogOutputManager getInstance() {
    return _instance;
  }

  ///日志
  final List<LogOutput> _otherLogOutput = [
    PlatformLoggerOutput.instance,
    FileLoggerOut.getInstance()
  ];
  void addLogOutput(LogOutput logOutput) {
    _otherLogOutput.add(logOutput);
  }

  @override
  void output(OutputEvent event) {
    if (_otherLogOutput.isNotEmpty) {
      for (var element in _otherLogOutput) {
        element.output(event);
      }
    } else {
      // ignore: avoid_print
      event.lines.forEach(print);
    }
  }
}

///日志写入文件
class FileLoggerOut extends LogOutput {
  IOSink? _sink;
  String? logPath;

  FileLoggerOut._internal() {
    _initConfig();
  }
  static final _instance = FileLoggerOut._internal();
  static FileLoggerOut getInstance() {
    return _instance;
  }

  void _initConfig() {
    _getAppCacheDirectory().then((value) {
      if (value == null) {
        return;
      }
      DateTime dateTime = DateTime.now();
      String logDirectory = '${value.path}/logger';
      String fileName =
          'log_${dateTime.year}_${dateTime.month}_${dateTime.day}.txt';
      String path = '$logDirectory/$fileName';
      logPath = path;
      debugPrint('日志文件地址:$path');
      Directory logDir = Directory(logDirectory);
      if (!logDir.existsSync()) {
        logDir.createSync(recursive: true);
      } else {
        //删除过去的日志
        List<FileSystemEntity> fileList = logDir.listSync();
        for (FileSystemEntity element in fileList) {
          String elementFileName = basename(element.path);
          DateTime modifiedDateTime = element.statSync().modified;
          bool canDelete = elementFileName != fileName;
          //用天比较，超出6天差距就删除
          if ((dateTime.day - modifiedDateTime.day) < 6) {
            canDelete = false;
          }
          if (canDelete) {
            element.delete();
          }
        }
      }
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      _sink = file.openWrite(
        mode: FileMode.writeOnlyAppend,
        encoding: utf8,
      );
    });
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }

  Future<Directory?> _getAppCacheDirectory() async {
    if (kIsWeb) {
      return null;
    }
    if (Platform.isAndroid) {
      return getExternalStorageDirectory();
    }
    if (Platform.isIOS) {
      return getTemporaryDirectory();
    }
    if (Platform.isMacOS) {
      ///Users/xx/Library/Containers/com.huastart.vpn/Data/Library/Caches
      ///~/Library/Containers/com.huastart.vpn/Data/Library/Caches
      return getTemporaryDirectory();
    }
    return null;
  }
}

//自定义日志格式
void printLog(Object message) {
  if (kDebugMode) {
    StackTrace currentTrace = StackTrace.current;
    String traceString = currentTrace.toString().split('\n')[1];
    int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var fileInfo = traceString.substring(indexOfFileName);
    fileInfo = fileInfo.replaceFirst(')', '');
    // var listOfInfos = fileInfo.split(':');
    // String fileName = listOfInfos[0];
    // int lineNumber = int.parse(listOfInfos[1]);
    // var columnStr = listOfInfos[2];
    // columnStr = columnStr.replaceFirst(')', '');
    logger.i('$fileInfo: ${message.toString()}');
  } else if (kReleaseMode) {
  } else if (kProfileMode) {}
}
