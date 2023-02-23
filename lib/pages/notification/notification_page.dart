import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      child: ListView.separated(
        separatorBuilder: (c, index) {
          return Divider(
            color: Colors.grey[100]!,
            height: 1,
            thickness: 1,
          );
        },
        itemBuilder: (c, index) {
          return ListTile(
            title: Text('消息：$index'),
            subtitle: const Text(
              '这是一个最简单的消息',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          );
        },
        itemCount: 100,
      ),
    );
  }
}
