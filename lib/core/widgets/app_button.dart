import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;

  static const _iconSize = 18.0;
  static const _iconGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                _ConstrainedButtonIcon(icon: icon!),
                const SizedBox(width: _iconGap),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}

class _ConstrainedButtonIcon extends StatelessWidget {
  const _ConstrainedButtonIcon({required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppButton._iconSize,
      child: IconTheme.merge(
        data: const IconThemeData(size: AppButton._iconSize),
        child: FittedBox(child: icon),
      ),
    );
  }
}
