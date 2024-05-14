import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';

import '../../style/text_field_style.dart';

///@Description TODO
///@Author jd
class SettingProxyPage extends StatefulWidget {
  const SettingProxyPage({Key? key}) : super(key: key);

  @override
  State createState() => _SettingProxyPageState();
}

class _SettingProxyPageState extends State<SettingProxyPage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  void initState() {
    if (Network.getInstance().getProxyIpAddress() != null) {
      List<String> list = Network.getInstance().getProxyIpAddress()!.split(':');
      _ipController.text = list.first;
      _portController.text = list.last;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: const Text('代理配置'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _ipController,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              //只允许输入字母数字*
              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              // isCollapsed: true, //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 8), //内容内边距，影响高度
              border: dividerBorder(),
              enabledBorder: dividerBorder(),
              focusedBorder: dividerBorder(),
              label: const Text(
                '请输入ip地址，如127.0.0.1',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
          TextField(
            controller: _portController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              //只允许输入字母数字*
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
            decoration: InputDecoration(
              // isCollapsed: true, //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 8), //内容内边距，影响高度
              border: dividerBorder(),
              enabledBorder: dividerBorder(),
              focusedBorder: dividerBorder(),
              label: const Text(
                '请输入端口，如8888',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: const Text('保存'),
              onPressed: () {
                Network.getInstance().setProxyIpAddress(
                    '${_ipController.text}:${_portController.text}');
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
