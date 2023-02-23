import 'package:flutter_core/flutter_core.dart';

class ReleaseInfo {
  ReleaseInfo(
      {this.id, this.name, this.path, this.info, this.flag, this.createTime});
  final int? id;
  final String? name;
  final String? path;
  final String? info;
  final String? flag;
  final String? createTime;

  factory ReleaseInfo.fromJson(Map map) {
    int id = map.getInt("id");
    String name = map.getString("name");
    String path = map.getString("path");
    String flag = map.getString("flag");
    String info = map.getString("info");
    String createTime = map.getString("create_time");
    return ReleaseInfo(
        id: id,
        name: name,
        path: path,
        flag: flag,
        info: info,
        createTime: createTime);
  }
}
