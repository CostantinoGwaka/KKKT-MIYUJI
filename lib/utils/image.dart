import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/utils/dimension.dart';
import 'package:lottie/lottie.dart';

class ImagePreview extends StatelessWidget {
  final String img;
  final BoxFit fit;
  final bool filter;
  final Color filterColor;
  final double? height;
  final double? width;

  const ImagePreview({
    Key? key,
    required this.img,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.filter = false,
    this.filterColor = Colors.black45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return img.contains('null')
        ? Image.asset(
            'assets/images/no_image.png',
            fit: BoxFit.cover,
            width: width,
          )
        : CachedNetworkImage(
            fit: fit,
            height: height,
            width: width,
            imageUrl: img,
            colorBlendMode: BlendMode.darken,
            color: filter ? filterColor : null,
            progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
              height: 10,
              width: 20,
              child: Center(
                child: Lottie.asset(
                  'assets/animation/image_loading.json',
                  height: 100,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: height,
              width: jtdeviceWidth(context),
              child: Image.asset(
                'assets/images/no_image.png',
                fit: BoxFit.cover,
                width: jtdeviceWidth(context),
              ),
            ),
          );
  }
}
