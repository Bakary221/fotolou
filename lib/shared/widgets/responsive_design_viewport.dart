import 'dart:math' as math;

import 'package:flutter/material.dart';

class ResponsiveDesignViewport extends StatelessWidget {
  const ResponsiveDesignViewport({
    required this.child,
    this.minimumHeight = 720,
    super.key,
  });

  final Widget child;
  final double minimumHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : minimumHeight;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: constraints.maxWidth,
            height: math.max(viewportHeight, minimumHeight),
            child: child,
          ),
        );
      },
    );
  }
}
