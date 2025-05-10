import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssets {
  SvgAssets._(); 

  static const String botMessageSquare = 'assets/icon/bot-message-square.svg';
  static const String house = 'assets/icon/house.svg';
  static const String book = 'assets/icon/book-copy.svg';
  static const String fileHeart = 'assets/icon/file-heart.svg';
  static const String circleUser = 'assets/icon/circle-user-round.svg';
}

class SvgIcon extends StatelessWidget {
  final String assetName;
  final double? size;
  final Color? color;

  const SvgIcon(
    this.assetName, {
    Key? key,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
