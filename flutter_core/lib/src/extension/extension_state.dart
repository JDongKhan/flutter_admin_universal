import 'package:flutter/widgets.dart';

/// @author jd

extension ExtensionState on State {
  ///为state生成widget
  Widget toWidget({Key? key}) {
    return _CommonWidget(
      state: this,
      key: key,
    );
  }
}

class _CommonWidget extends StatefulWidget {
  const _CommonWidget({Key? key, required this.state}) : super(key: key);
  final State state;
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => state;
}
