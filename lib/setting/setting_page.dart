import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

/// @author jd

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(10),
      child: Container(
        width: 60,
        color: Colors.blueGrey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: IconButton(
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    Icons.close,
                    size: 18,
                  ),
                  onPressed: () {
                    UniversalDashboard.of(context)?.openOrCloseSetting();
                  },
                ),
              ),
              height: 60,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.people_alt_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.my_library_books),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.subject_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.compass_calibration_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
