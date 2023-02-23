import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../logger/platform_logger_output.dart';

class LogConsolePage extends StatefulWidget {
  final bool dark;
  final bool showCloseButton;
  final VoidCallback? backAction;

  const LogConsolePage({
    Key? key,
    this.dark = true,
    this.showCloseButton = false,
    this.backAction,
  }) : super(key: key);

  @override
  State createState() => _LogConsolePageState();
}

class _LogConsolePageState extends State<LogConsolePage> {
  late PlatformLoggerOutputCallback _callback;

  List<RenderedEvent> _filteredBuffer = [];

  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  Level _filterLevel = Level.verbose;
  double _logFontSize = 12;

  bool _scrollListenerEnabled = true;
  bool _followBottom = true;

  @override
  void initState() {
    super.initState();

    _callback = (e) {
      Future.delayed(const Duration(milliseconds: 0), () {
        _refreshFilter();
      });
    };

    //add callback
    PlatformLoggerOutput.instance.addOutputListener(_callback);

    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      setState(() {
        _followBottom = scrolledToBottom;
      });
    });

    Future.delayed(const Duration(milliseconds: 0), () {
      _refreshFilter();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _refreshFilter() {
    var newFilteredBuffer =
        PlatformLoggerOutput.instance.renderedBuffer.where((it) {
      var logLevelMatches = it.level.index >= _filterLevel.index;
      if (!logLevelMatches) {
        return false;
      } else if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        return it.lowerCaseText.contains(filterText);
      } else {
        return true;
      }
    }).toList();
    setState(() {
      _filteredBuffer = newFilteredBuffer;
    });

    if (_followBottom) {
      Future.delayed(Duration.zero, _scrollToBottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.dark
          ? ThemeData(
              brightness: Brightness.dark,
            )
          : ThemeData(
              brightness: Brightness.light,
            ),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTopBar(),
            Expanded(
              child: _buildLogContent(),
            ),
            _buildBottomBar(),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _followBottom ? 0 : 1,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              mini: true,
              clipBehavior: Clip.antiAlias,
              onPressed: _scrollToBottom,
              child: Icon(
                Icons.arrow_downward,
                color: widget.dark ? Colors.white : Colors.lightBlue[900],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogContent() {
    return Container(
      color: widget.dark ? Colors.black : Colors.grey[150],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1600,
          child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemBuilder: (context, index) {
              var logEntry = _filteredBuffer[index];
              return Text.rich(
                logEntry.span,
                key: Key(logEntry.id.toString()),
                style: TextStyle(fontSize: _logFontSize),
              );
            },
            itemCount: _filteredBuffer.length,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return LogBar(
      dark: widget.dark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            "Log Console",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _logFontSize++;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _logFontSize--;
              });
            },
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                if (widget.backAction != null) {
                  widget.backAction?.call();
                }
                // Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return LogBar(
      dark: widget.dark,
      top: false,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14),
              controller: _filterController,
              onChanged: (s) => _refreshFilter(),
              decoration: const InputDecoration(
                labelText: "Filter log output",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          DropdownButton<Level>(
            value: _filterLevel,
            items: const [
              DropdownMenuItem(
                value: Level.verbose,
                child: Text(
                  "VERBOSE",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              DropdownMenuItem(
                value: Level.debug,
                child: Text(
                  "DEBUG",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              DropdownMenuItem(
                value: Level.info,
                child: Text(
                  "INFO",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              DropdownMenuItem(
                value: Level.warning,
                child: Text(
                  "WARNING",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              DropdownMenuItem(
                value: Level.error,
                child: Text(
                  "ERROR",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              DropdownMenuItem(
                value: Level.wtf,
                child: Text(
                  "WTF",
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
            onChanged: (value) {
              _filterLevel = value ?? Level.verbose;
              _refreshFilter();
            },
          )
        ],
      ),
    );
  }

  void _scrollToBottom() async {
    _scrollListenerEnabled = false;

    setState(() {
      _followBottom = true;
    });

    var scrollPosition = _scrollController.position;
    await _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    _scrollListenerEnabled = true;
  }

  @override
  void dispose() {
    PlatformLoggerOutput.instance.removeOutputListener();
    super.dispose();
  }
}

class LogBar extends StatelessWidget {
  final bool dark;
  final Widget child;
  final bool top;
  const LogBar({
    Key? key,
    this.dark = false,
    required this.child,
    this.top = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? Colors.blueGrey[900] : Colors.white,
      child: SafeArea(
        top: top,
        bottom: !top,
        child: SizedBox(
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (!dark)
                  BoxShadow(
                    color: Colors.grey[400]!,
                    blurRadius: 3,
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
