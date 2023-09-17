import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_loading.dart';

class ImageAsIcon extends StatelessWidget {
  final String? image;
  final bool? isActive;
  final bool? orignalColor;
  final bool? fromNetwork;
  final Color? defaultColor;
  final Color? activeColor;
  final double? height;
  final double? width;
  final BlendMode? blendColor;
  final BoxFit? boxFit;
  const ImageAsIcon(
      {Key? key,
      required this.image,
      this.fromNetwork = false,
      this.isActive = false,
      this.defaultColor,
      this.height,
      this.width,
      this.activeColor,
      this.blendColor = BlendMode.srcIn,
      this.orignalColor = false,
      this.boxFit})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print(image + " || " + blendColor.toString());
    String exstentionImage = image!.split(".").last.toLowerCase();
    return fromNetwork!
        ? exstentionImage == "svg"
            ? SvgPicture.network(
                image ?? '',
                height: height ?? 32,
                width: width ?? 35,
                fit: BoxFit.fill,
                color: orignalColor!
                    ? null
                    : isActive!
                        ? activeColor ?? const Color(0xff212121)
                        : defaultColor ?? const Color(0xffBCBCBC),
                placeholderBuilder: (_) {
                  return const CustomLoading();
                },
                colorBlendMode: blendColor ?? BlendMode.saturation,
              )
            : ColorFiltered(
                colorFilter: ColorFilter.mode(
                    orignalColor!
                        ? Colors.transparent
                        : isActive!
                            ? activeColor ?? const Color(0xff212121)
                            : defaultColor ?? const Color(0xffBCBCBC),
                    BlendMode.saturation),
                child: Image.network(
                  image!,
                  width: width ?? 30,
                  fit: BoxFit.fill,
                  height: height ?? 30,
                ),
              )
        : Tab(
            icon: Center(
                child: SvgPicture.asset(
            image!,
            color: orignalColor!
                ? null
                : isActive!
                    ? activeColor ?? const Color(0xff212121)
                    : defaultColor ?? const Color(0xffBCBCBC),
            width: width ?? 30,
            height: height ?? 30,
            fit: BoxFit.fill,
            colorBlendMode: blendColor ?? BlendMode.saturation,
          )));
  }
}
