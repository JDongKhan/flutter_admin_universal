import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

import '../utils/object_utils.dart';

/// 带有容错的imageview
///
/// @author jd
class ImageLoaderWidget extends StatelessWidget {
  const ImageLoaderWidget({
    Key? key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.placeholderFit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.hasBackground = true,
    this.defaultImage = 'default_image',
  }) : super(key: key);

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxFit placeholderFit;
  final String defaultImage;
  final Alignment alignment;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      foregroundDecoration: hasBackground
          ? const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          : null,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (isBlank(imageUrl)) {
      return Image.asset(
        AssetBundleUtils.getImgPath(defaultImage),
        fit: placeholderFit,
      );
    }
    String url = imageUrl!;
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          // color: const Color.fromRGBO(0, 0, 0, 0.1),
          borderRadius: BorderRadius.circular(6.0),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (BuildContext context, String url) => Image.asset(
        AssetBundleUtils.getImgPath(defaultImage),
        fit: placeholderFit,
      ),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          Image.asset(
        AssetBundleUtils.getImgPath(defaultImage),
        fit: placeholderFit,
      ),
    );
  }
}
