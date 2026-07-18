import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

class AppOtpInput extends StatefulWidget {
  const AppOtpInput({
    required this.onChanged,
    this.length = 6,
    this.scale = 1,
    this.boxKeyBuilder,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final int length;
  final double scale;
  final Key Function(int index)? boxKeyBuilder;

  @override
  State<AppOtpInput> createState() => _AppOtpInputState();
}

class _AppOtpInputState extends State<AppOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < widget.length; index++)
            _OtpDigitField(
              key: ValueKey(index),
              boxKey: widget.boxKeyBuilder?.call(index),
              index: index,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              scale: widget.scale,
              autofillHints: index == 0
                  ? const [AutofillHints.oneTimeCode]
                  : null,
              onChanged: (value) => _handleChanged(index, value),
            ),
        ],
      ),
    );
  }

  void _handleChanged(int index, String rawValue) {
    final value = rawValue.replaceAll(RegExp(r'\D'), '');
    if (value.length > 1) {
      _distributeCode(index, value);
      return;
    }

    if (value != rawValue) {
      _controllers[index].text = value;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _notifyCodeChanged();
  }

  void _distributeCode(int startIndex, String code) {
    final availableLength = widget.length - startIndex;
    final digits = code.substring(0, code.length.clamp(0, availableLength));
    for (var offset = 0; offset < digits.length; offset++) {
      _controllers[startIndex + offset].text = digits[offset];
    }

    final focusIndex = (startIndex + digits.length).clamp(0, widget.length - 1);
    _focusNodes[focusIndex].requestFocus();
    _notifyCodeChanged();
  }

  void _notifyCodeChanged() {
    widget.onChanged(_controllers.map((controller) => controller.text).join());
  }
}

class _OtpDigitField extends StatelessWidget {
  const _OtpDigitField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.scale,
    required this.onChanged,
    this.boxKey,
    this.autofillHints,
    super.key,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double scale;
  final ValueChanged<String> onChanged;
  final Key? boxKey;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final isActive = focusNode.hasFocus;
        final foregroundColor = isActive ? AppColors.focusBlue : AppColors.ink;

        return Semantics(
          textField: true,
          label: 'Chiffre ${index + 1} du code de vérification',
          child: SizedBox(
            width: 48 * scale,
            height: 56 * scale,
            child: DecoratedBox(
              key: boxKey,
              decoration: BoxDecoration(
                color: isActive ? AppColors.white : AppColors.gray50,
                borderRadius: BorderRadius.circular(12 * scale),
                border: Border.all(
                  color: isActive ? AppColors.focusBlue : AppColors.gray100,
                  width: (isActive ? 2 : 1) * scale,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowBlack05,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  autofillHints: autofillHints,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    counterText: '',
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    color: foregroundColor,
                    fontFamily: AppFonts.poppins,
                    fontSize: 20 * scale,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                  strutStyle: StrutStyle(
                    forceStrutHeight: true,
                    height: 1,
                    fontSize: 20 * scale,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
