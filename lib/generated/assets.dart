import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Assets {
  Assets._();

  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  final SvgGenImage a5502459892648261 = const SvgGenImage(
    'assets/images/55024598_9264826 1.svg',
  );
  final AssetGenImage gettyImages13156077882 = const AssetGenImage(
    'assets/images/GettyImages-1315607788 2.png',
  );
  final AssetGenImage group1000002835 = const AssetGenImage(
    'assets/images/Group 1000002835.png',
  );
  final AssetGenImage home = const AssetGenImage('assets/images/Home.png');
  final SvgGenImage oBJECTS012 = const SvgGenImage(
    'assets/images/OBJECTS012.svg',
  );
  final SvgGenImage passwordIconlyPro = const SvgGenImage(
    'assets/images/Password - Iconly Pro.svg',
  );
  final SvgGenImage plusIconlyPro = const SvgGenImage(
    'assets/images/Plus - Iconly Pro.svg',
  );
  final SvgGenImage profileIconlyPro = const SvgGenImage(
    'assets/images/Profile - Iconly Pro.svg',
  );
  final SvgGenImage unlockIconlyPro = const SvgGenImage(
    'assets/images/Unlock - Iconly Pro.svg',
  );
  final AssetGenImage calendar = const AssetGenImage(
    'assets/images/calendar.png',
  );
  final SvgGenImage objects = const SvgGenImage('assets/images/objects.svg');
  final AssetGenImage personal = const AssetGenImage(
    'assets/images/personal.png',
  );
  final AssetGenImage work = const AssetGenImage('assets/images/work.png');
}

class $AssetsIconGen {
  const $AssetsIconGen();

  final AssetGenImage icon = const AssetGenImage('assets/icon/icon.png');
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  Widget custom({
    Key? key,
    required Widget Function(BuildContext context, String assetPath) builder,
  }) {
    return Builder(
      key: key,
      builder: (context) => builder(context, _assetName),
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    Clip clipBehavior = Clip.hardEdge,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: color != null ? ColorFilter.mode(color, colorBlendMode) : null,
      clipBehavior: clipBehavior,
    );
  }

  Widget custom({
    Key? key,
    required Widget Function(BuildContext context, String assetPath) builder,
  }) {
    return Builder(
      key: key,
      builder: (context) => builder(context, _assetName),
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
