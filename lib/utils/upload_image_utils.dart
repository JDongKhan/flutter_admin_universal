import 'package:dio/dio.dart';
import 'package:flutter_admin_universal/network/network_utils.dart';
import 'package:flutter_admin_universal/service/environment.dart';
import 'package:http_parser/http_parser.dart';

///@Description TODO
///@Author jd

class UploadImageUtils {
  ///获取验证信息
  Future _getAuthenticationInfo(String fileName) async {
    String authUrl = 'https://apicarrefourlsy.xx.com';
    if (environment.environment == Environment.sit) {
      authUrl = 'https://portalsit.xx.com';
    } else if (environment.environment == Environment.pre) {
      authUrl = 'https://portalpre.xx.com';
    }
    authUrl = '$authUrl/carrbshop-web/settle/ossAuthentication';
    NetworkResponse response =
        await Network.post(authUrl, data: {'objectName': fileName});

    return null;
  }

  ///上传图片
  Future uploadImage(String filePath) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    //先鉴权
    var authInfo = await _getAuthenticationInfo('$ts');
    if (authInfo == null) {
      return;
    }
    String downloadUrl = authInfo['downloadUrl'];
    String uploadUrl = authInfo['uploadUrl'];
    String accessId = authInfo['accessId'];
    String expireTime = authInfo['expireTime'];
    String signature = authInfo['signature'];
    String requestURL =
        '$uploadUrl?SDOSSAccessKeyId=$accessId&Expires=$expireTime&Signature=$signature';

    // 单个文件上传
    var formData = FormData.fromMap({
      'name': 'file',
      'file': await MultipartFile.fromFile(
        filePath,
        filename: '$ts',
        contentType: MediaType('image', 'png'),
      ),
    });

    Network.put(requestURL, data: formData);
  }
}
