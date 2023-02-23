import 'dart:math';

import '/http/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import '../../utils/login_util.dart';
import '../../utils/navigation_util.dart';
import '../../widget/custom_verification_code.dart';

/// @author jd

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController =
      TextEditingController(text: "admin");
  final TextEditingController _passwordController =
      TextEditingController(text: "admin");
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  String _code = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: '登录',
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    //或者套一个Title组件
    return Scaffold(
      body: Container(
        color: Colors.orange.withAlpha(10),
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                  child: Text(
                "后台管理系统",
                style: TextStyle(fontSize: 16, color: Colors.blue),
                textScaleFactor: 2,
              )),
              const SizedBox(height: 20.0),
              _buildLoginForm(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 500,
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Spinner(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      decoration: buildInputDecoration(
                        prefixIcon: const Icon(
                          Icons.account_box_outlined,
                          color: Colors.blue,
                        ),
                        labelText: '平台类型',
                      ),
                      items: [
                        SpinnerItem<String>(
                          value: "1",
                          title: "平台1",
                        ),
                        SpinnerItem<String>(
                          value: "2",
                          title: "平台2",
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextFormField(
                      focusNode: _focusNodeUserName,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      controller: _accountController,
                      validator: (value) {
                        if (value == null || value == '') {
                          return '账号不能为空';
                        }
                        return null;
                      },
                      decoration: buildInputDecoration(
                        labelText: '账号',
                        prefixIcon: const Icon(
                          Icons.account_box_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      onSaved: (v) {},
                      onFieldSubmitted: (v) {
                        _focusNodePassword.requestFocus();
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextFormField(
                      focusNode: _focusNodePassword,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value == '') {
                          return '密码不能为空';
                        }
                        return null;
                      },
                      decoration: buildInputDecoration(
                        labelText: '密码',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.blue,
                        ),
                      ),
                      onSaved: (v) {},
                      onFieldSubmitted: (v) {},
                    ),
                  ),
                  //验证码
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: true,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            controller: _codeController,
                            validator: (value) {
                              if (value == null || value == '') {
                                return '验证码不能为空';
                              }
                              return null;
                            },
                            decoration: buildInputDecoration(
                              labelText: '验证码',
                              prefixIcon: const Icon(
                                Icons.qr_code,
                                color: Colors.blue,
                              ),
                            ),
                            onSaved: (v) {},
                            onFieldSubmitted: (v) {},
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              _getCode();
                            },
                            child: CustomVerificationCode(
                              width: 70,
                              height: 30,
                              code: _code,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: _register,
                        child: const Text(
                          '注册',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          '忘记密码',
                          style: TextStyle(color: Colors.black45),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 50, right: 50, top: 10, bottom: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: const Text('登录',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
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
              child: const Icon(
                Icons.account_box_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      UserService.login(_accountController.text, _accountController.text)
          .then((value) {
        if (value != null) {
          NavigationUtil.replace("/");
        }
      });
    }
  }

  void _register() {
    LoginUtil.isLoggedIn = true;
    NavigationUtil.go("/");
  }

  /// 调用随机数方法
  _getCode() {
    _code = '';
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    for (var i = 0; i < 4; i++) {
      String charOrNum = Random().nextInt(2) % 2 == 0 ? "char" : "num";
      switch (charOrNum) {
        case "char":
          _code += alphabet[Random().nextInt(alphabet.length)];
          break;
        case "num":
          _code += Random().nextInt(9).toString();
          break;
      }
      setState(() {});
    }
  }
}
