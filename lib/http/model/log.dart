import 'package:flutter_core/flutter_core.dart';

class Log {
  final int? id;
  final String? message;
  final String? method;
  final String? time;
  final int? userId;
  final String? version;
  final String? operationIp;
  final String? operationUrl;
  final String? operationLocation;
  Log(
      {this.id,
      this.message,
      this.method,
      this.time,
      this.userId,
      this.version,
      this.operationIp,
      this.operationUrl,
      this.operationLocation});

  factory Log.fromJson(Map map) {
    int id = map.getInt("id");
    int userId = map.getInt("userId");
    String message = map.getString("message");
    String method = map.getString("method");
    String time = map.getString("time");
    String version = map.getString("version");
    String operationIp = map.getString("operationIp");
    String operationUrl = map.getString("operationUrl");
    String operationLocation = map.getString("operationLocation");
    return Log(
      id: id,
      message: message,
      method: method,
      time: time,
      userId: userId,
      version: version,
      operationIp: operationIp,
      operationUrl: operationUrl,
      operationLocation: operationLocation,
    );
  }
}
