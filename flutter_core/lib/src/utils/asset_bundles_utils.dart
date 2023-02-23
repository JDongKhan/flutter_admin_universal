import 'package:flutter/services.dart' show rootBundle;

/// @author jd
///获取本地资源
class AssetBundleUtils {
  static String getImgPath(String? name, {String format = 'png'}) {
    assert(name != null,"");
    if (name == null) {
      return "";
    }
    if (name.contains('.')) {
      format = name.split('.').last;
      name = name.split('.').first;
    }
    return 'assets/images/$name.$format';
  }

  static String getIconPath(String? name, {String format = 'png'}) {
    return 'assets/icons/$name.$format';
  }

  static Future<String> loadString(String path) async {
    return rootBundle.loadString(path);
  }
}

extension AssetBundlesExtensionString on String {

  String get img =>   AssetBundleUtils.getImgPath(this);

  String get icon => AssetBundleUtils.getIconPath(this);
  
}