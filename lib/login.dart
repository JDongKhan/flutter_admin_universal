import 'package:flutter/material.dart';
import 'package:flutter_admin_universal/utils/login_util.dart';
import 'package:routemaster/routemaster.dart';

import 'network/network_utils.dart';
import 'service/environment.dart';

/// @author jd

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange.withAlpha(10),
        padding: const EdgeInsets.only(top: 10),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text(
              "后台管理系统",
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textScaleFactor: 2,
            )),
            SizedBox(height: 20.0),
            _buildLoginForm(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 500,
              height: 360,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodeUserName,
                        initialValue: 'JD',
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '账号',
                          icon: Icon(
                            Icons.account_box_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {},
                        onFieldSubmitted: (v) {
                          focusNodePassword.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodePassword,
                        obscureText: true,
                        initialValue: '123',
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '密码',
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {},
                        onFieldSubmitted: (v) {
                          _login();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            '注册',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: _register,
                        ),
                        TextButton(
                          child: Text(
                            '忘记密码',
                            style: TextStyle(color: Colors.black45),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.orange.withAlpha(200),
                child: Icon(
                  Icons.account_box_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            height: 360,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Text('登录',
                    style: TextStyle(color: Colors.white70, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _login() {
    LoginUtil.isLoggedIn = true;
    _callRequest();
    Routemaster.of(context).replace('/');
  }

  _register() {
    LoginUtil.isLoggedIn = true;
    Routemaster.of(context).replace('/');
  }

  void _callRequest() async {
    var res = await Network.get(environment.path.hostConfig.baseUrl);
    debugPrint('result:${res.data}');
  }
}
