import 'package:flutter_core/flutter_core.dart';

class User {
  User(this.id, this.name, this.account, this.phone, this.isAdmin);

  final int id;
  final String name;
  final String account;
  final String phone;
  final String isAdmin;

  factory User.fromJson(Map map) {
    int id = map.getInt("id");
    String name = map.getString("name");
    String account = map.getString("account");
    String phone = map.getString("phone");
    String isAdmin = map.getString("isAdmin");
    return User(id, name, account, phone, isAdmin);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['account'] = account;
    map['phone'] = phone;
    map['isAdmin'] = isAdmin;
    return map;
  }
}
