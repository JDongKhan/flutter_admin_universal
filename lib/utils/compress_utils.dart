///@Description TODO
///@Author jd

class CompressUtils {
  //flutter_luban https://juejin.cn/post/6847902207572967432
  //鲁班压缩库核心代码
  // static String _lubanCompress(CompressObject object) {
  //   //根据CompressObject对象中的File通过Uint8List的readAsBytesSync()方法获取到List<int>数组
  //   //通过Image中的decodeImage()初始化image对象
  //   //注意：此Imgae对象为'package:image/image.dart'中的对象，并非我们常用的Widget对象
  //   Image image = decodeImage(object.imageFile.readAsBytesSync());
  //   //获取file长度并打印
  //   var length = object.imageFile.lengthSync();
  //   print(object.imageFile.path);
  //
  //   bool isLandscape = false;
  //   //jpg类型数组
  //   const List<String> jpgSuffix = ["jpg", "jpeg", "JPG", "JPEG"];
  //   //png类型数组
  //   const List<String> pngSuffix = ["png", "PNG"];
  //
  //   //调用_parseType()方法判断图片类型
  //   bool isJpg = _parseType(object.imageFile.path, jpgSuffix);
  //   bool isPng = false;
  //
  //   if (!isJpg) isPng = _parseType(object.imageFile.path, pngSuffix);
  //
  //   //初始化size width height
  //   double size;
  //   int fixelW = image.width;
  //   int fixelH = image.height;
  //   //
  //   double thumbW = (fixelW % 2 == 1 ? fixelW + 1 : fixelW).toDouble();
  //   double thumbH = (fixelH % 2 == 1 ? fixelH + 1 : fixelH).toDouble();
  //   //横纵比
  //   double scale = 0;
  //   if (fixelW > fixelH) {
  //     scale = fixelH / fixelW;
  //     var tempFixelH = fixelW;
  //     var tempFixelW = fixelH;
  //     fixelH = tempFixelH;
  //     fixelW = tempFixelW;
  //     isLandscape = true;
  //   } else {
  //     scale = fixelW / fixelH;
  //   }
  //   var decodedImageFile;
  //   //目前只支持jpg和png的压缩，否则抛出异常提示
  //   if (isJpg)
  //     decodedImageFile = new File(
  //         object.path + '/img_${DateTime.now().millisecondsSinceEpoch}.jpg');
  //   else if (isPng)
  //     decodedImageFile = new File(
  //         object.path + '/img_${DateTime.now().millisecondsSinceEpoch}.png');
  //   else
  //     throw Exception("flutter_luban don't support this image type");
  //   //同步检查decodedImageFile文件是否存在
  //   if (decodedImageFile.existsSync()) {
  //     //同步删除decodedImageFile文件
  //     decodedImageFile.deleteSync();
  //   }
  //   //根据图片的横纵比例和传入的图片大小重新计算图片size
  //   var imageSize = length / 1024;
  //   if (scale <= 1 && scale > 0.5625) {
  //     if (fixelH < 1664) {
  //       if (imageSize < 150) {
  //         decodedImageFile
  //             .writeAsBytesSync(encodeJpg(image, quality: object.quality));
  //         return decodedImageFile.path;
  //       }
  //       size = (fixelW * fixelH) / pow(1664, 2) * 150;
  //       size = size < 60 ? 60 : size;
  //     } else if (fixelH >= 1664 && fixelH < 4990) {
  //       thumbW = fixelW / 2;
  //       thumbH = fixelH / 2;
  //       size = (thumbH * thumbW) / pow(2495, 2) * 300;
  //       size = size < 60 ? 60 : size;
  //     } else if (fixelH >= 4990 && fixelH < 10240) {
  //       thumbW = fixelW / 4;
  //       thumbH = fixelH / 4;
  //       size = (thumbW * thumbH) / pow(2560, 2) * 300;
  //       size = size < 100 ? 100 : size;
  //     } else {
  //       int multiple = fixelH / 1280 == 0 ? 1 : fixelH ~/ 1280;
  //       thumbW = fixelW / multiple;
  //       thumbH = fixelH / multiple;
  //       size = (thumbW * thumbH) / pow(2560, 2) * 300;
  //       size = size < 100 ? 100 : size;
  //     }
  //   } else if (scale <= 0.5625 && scale >= 0.5) {
  //     if (fixelH < 1280 && imageSize < 200) {
  //       decodedImageFile
  //           .writeAsBytesSync(encodeJpg(image, quality: object.quality));
  //       return decodedImageFile.path;
  //     }
  //     int multiple = fixelH / 1280 == 0 ? 1 : fixelH ~/ 1280;
  //     thumbW = fixelW / multiple;
  //     thumbH = fixelH / multiple;
  //     size = (thumbW * thumbH) / (1440.0 * 2560.0) * 200;
  //     size = size < 100 ? 100 : size;
  //   } else {
  //     int multiple = (fixelH / (1280.0 / scale)).ceil();
  //     thumbW = fixelW / multiple;
  //     thumbH = fixelH / multiple;
  //     size = ((thumbW * thumbH) / (1280.0 * (1280 / scale))) * 500;
  //     size = size < 100 ? 100 : size;
  //   }
  //   //如果原始图片size小于计算完毕后图片size
  //   //则调用Image encodeJpg()方法进行质量压缩，并同步写入缓存且返回路径
  //   if (imageSize < size) {
  //     decodedImageFile
  //         .writeAsBytesSync(encodeJpg(image, quality: object.quality));
  //     return decodedImageFile.path;
  //   }
  //   //如果原始图片size大于计算完毕后图片size
  //   //根据横竖方向，调用copyResize()方法重设宽高属性给smallerImage赋值
  //   Image smallerImage;
  //   if (isLandscape) {
  //     smallerImage = copyResize(image,
  //         width: thumbH.toInt(),
  //         height: object.autoRatio ? null : thumbW.toInt());
  //   } else {
  //     smallerImage = copyResize(image,
  //         width: thumbW.toInt(),
  //         height: object.autoRatio ? null : thumbH.toInt());
  //   }
  //
  //   if (decodedImageFile.existsSync()) {
  //     decodedImageFile.deleteSync();
  //   }
  //   //根据传入的CompressMode枚举类型，调用对应的CompressImage()方法
  //   //本质都是调用Image encodeJpg()方法进行质量压缩，只是在image size上做了调整
  //   if (object.mode == CompressMode.LARGE2SMALL) {
  //     _large2SmallCompressImage(
  //       image: smallerImage,
  //       file: decodedImageFile,
  //       quality: object.quality,
  //       targetSize: size,
  //       step: object.step,
  //       isJpg: isJpg,
  //     );
  //   } else if (object.mode == CompressMode.SMALL2LARGE) {
  //     _small2LargeCompressImage(
  //       image: smallerImage,
  //       file: decodedImageFile,
  //       quality: object.step,
  //       targetSize: size,
  //       step: object.step,
  //       isJpg: isJpg,
  //     );
  //   } else {
  //     if (imageSize < 500) {
  //       _large2SmallCompressImage(
  //         image: smallerImage,
  //         file: decodedImageFile,
  //         quality: object.quality,
  //         targetSize: size,
  //         step: object.step,
  //         isJpg: isJpg,
  //       );
  //     } else {
  //       _small2LargeCompressImage(
  //         image: smallerImage,
  //         file: decodedImageFile,
  //         quality: object.step,
  //         targetSize: size,
  //         step: object.step,
  //         isJpg: isJpg,
  //       );
  //     }
  //   }
  //   return decodedImageFile.path;
  // }

}
