import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/platform/platform_adapter.dart';
import 'package:flutter_admin_universal/widget/universal_dashboard.dart';

/// @author jd

class MainTopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFF5F5F5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2.0, 5.0), //阴影xy轴偏移量
            blurRadius: 15.0, //阴影模糊程度
            spreadRadius: 1.0, //阴影扩散程度
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: UniversalDashboard.isMobile() ? 44 : 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  UniversalDashboard.of(context)?.openOrCloseLeftMenu();
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    height: 20,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '站内搜索',
                      ),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.query_builder_outlined,
                      size: 16,
                    ),
                    onPressed: () {
                      platformAdapter.downloadFile(
                          "https://imgservice.suning.cn/uimg1/b2c/image/j3RBQIEvtmT2JMD7wJ9-rQ.jpg_800w_800h_4e");
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      size: 16,
                    ),
                    onPressed: () {
                      _openFile();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 16,
                    ),
                    onPressed: () {
                      UniversalDashboard.of(context)?.openOrCloseSetting();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFile() async {
    platformAdapter.selectFileAndUpload();
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    //
    // if (result != null) {
    //   debugPrint('${result.files.length}');
    //   PlatformFile file = result.files.single;
    //   File srcfile = File(file.bytes!.toList(), file.name);
    //   debugPrint('${srcfile}');
    // } else {
    //   // User canceled the picker
    // }
  }
}
