import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/flutter_core.dart';

import '../logger/ui/ansi_parser.dart';

///@Description TODO
///@Author jd

int _bufferSize = 100;

typedef PlatformLoggerOutputCallback = void Function(OutputEvent event);

class RenderedEvent {
  RenderedEvent(this.id, this.level, this.span, this.lowerCaseText);
  final int id;
  final Level level;
  final TextSpan span;
  final String lowerCaseText;
}

class PlatformLoggerOutput extends LogOutput {
  var _currentId = 0;

  /// 构造方法私有化
  PlatformLoggerOutput._internal();
  static PlatformLoggerOutput get instance => _getInstance();
  static PlatformLoggerOutput? _instance;
  static PlatformLoggerOutput _getInstance() {
    _instance ??= PlatformLoggerOutput._internal();
    return _instance!;
  }

  ListQueue<RenderedEvent> renderedBuffer = ListQueue();
  bool openLogCollection = false;

  PlatformLoggerOutputCallback? outputCallback;

  void addOutputListener(PlatformLoggerOutputCallback outputCallback) {
    this.outputCallback = outputCallback;
  }

  void removeOutputListener() {
    outputCallback = null;
  }

  @override
  void output(OutputEvent event) {
    event.lines.forEach(debugPrint);
    if (outputCallback != null) {
      outputCallback?.call(event);
    }
    if (openLogCollection) {
      _printLog(event);
    }
  }

  void _printLog(OutputEvent e) {
    if (renderedBuffer.length == _bufferSize) {
      renderedBuffer.removeFirst();
    }
    renderedBuffer.add(_renderEvent(e));
  }

  RenderedEvent _renderEvent(OutputEvent event) {
    var parser = AnsiParser(false);
    var text = event.lines.join('\n');
    parser.parse(text);
    return RenderedEvent(
      _currentId++,
      event.level,
      TextSpan(children: parser.spans),
      text.toLowerCase(),
    );
  }
}
