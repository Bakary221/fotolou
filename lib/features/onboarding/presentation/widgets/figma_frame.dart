import 'package:flutter/material.dart';

abstract final class FigmaFrameTokens {
  static const width = 440.0;
  static const height = 956.0;
}

class FigmaFrame extends StatelessWidget {
  const FigmaFrame({required this.builder, this.backgroundColor, super.key});

  final Color? backgroundColor;
  final Widget Function(BuildContext context, FigmaFrameMetrics metrics)
  builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final widthScale = size.width / FigmaFrameTokens.width;
        final heightScale = size.height / FigmaFrameTokens.height;
        final scale = widthScale < heightScale ? widthScale : heightScale;
        final scaledWidth = FigmaFrameTokens.width * scale;
        final scaledHeight = FigmaFrameTokens.height * scale;
        final metrics = FigmaFrameMetrics(
          scale: scale,
          xOffset: (size.width - scaledWidth) / 2,
          yOffset: (size.height - scaledHeight) / 2,
        );

        return ColoredBox(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          child: Stack(children: [builder(context, metrics)]),
        );
      },
    );
  }
}

class FigmaFrameMetrics {
  const FigmaFrameMetrics({
    required this.scale,
    required this.xOffset,
    required this.yOffset,
  });

  final double scale;
  final double xOffset;
  final double yOffset;

  double x(double value) => xOffset + value * scale;
  double y(double value) => yOffset + value * scale;
  double s(double value) => value * scale;
}
