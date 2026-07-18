import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.key});

  final T value;
  final String label;
  final Key? key;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final List<AppSegment<T>> segments;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _AppSegmentButton<T>(
                key: segment.key,
                segment: segment,
                isSelected: segment.value == selectedValue,
                onSelected: onChanged,
              ),
            ),
        ],
      ),
    );
  }
}

class _AppSegmentButton<T> extends StatelessWidget {
  const _AppSegmentButton({
    required this.segment,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final AppSegment<T> segment;
  final bool isSelected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isSelected ? null : () => onSelected(segment.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: AppColors.shadowBlack10,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              segment.label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.gray600,
                fontFamily: AppFonts.inter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
