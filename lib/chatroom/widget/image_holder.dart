import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miyuji/utils/spacer.dart';

class ImageView extends StatelessWidget {
  final String img;
  final BoxFit fit;
  final bool filter;
  final Color filterColor;
  final double height;

  ///encapsulate a network image
  const ImageView({super.key, this.img, this.height, this.fit = BoxFit.cover, this.filter = false, this.filterColor = Colors.black45});

  @override
  Widget build(BuildContext context) {
    return img.contains('null')
        ? Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            width: deviceWidth(context),
          )
        : CachedNetworkImage(
            fit: fit,
            height: height ?? deviceHeight(context),
            width: deviceWidth(context),
            imageUrl: img,
            colorBlendMode: BlendMode.darken,
            color: filter ? filterColor : null,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(height: 10, width: 20, child: Center(child: CircularProgressIndicator(value: downloadProgress.progress))),
            errorWidget: (context, url, error) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: height ?? deviceHeight(context),
                width: deviceWidth(context),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: deviceWidth(context),
                )),
          );
  }
}
