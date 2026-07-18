import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';

enum TicketHistoryStatus { served, cancelled }

class TicketHistoryEntry {
  const TicketHistoryEntry({
    required this.initials,
    required this.name,
    required this.date,
    required this.status,
  });

  final String initials;
  final String name;
  final String date;
  final TicketHistoryStatus status;
}

class TicketHistoryCard extends StatelessWidget {
  const TicketHistoryCard({required this.entry, super.key});

  final TicketHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final isServed = entry.status == TicketHistoryStatus.served;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray100),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack05,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HistoryAvatar(initials: entry.initials, isServed: isServed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontFamily: AppFonts.inter,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                  ),
                ),
                Text(
                  entry.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.gray600,
                    fontFamily: AppFonts.inter,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _HistoryStatusBadge(status: entry.status),
        ],
      ),
    );
  }
}

class _HistoryAvatar extends StatelessWidget {
  const _HistoryAvatar({required this.initials, required this.isServed});

  final String initials;
  final bool isServed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isServed ? AppColors.blue50 : AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: isServed ? AppColors.secondary : AppColors.gray600,
          fontFamily: AppFonts.inter,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 28 / 18,
        ),
      ),
    );
  }
}

class _HistoryStatusBadge extends StatelessWidget {
  const _HistoryStatusBadge({required this.status});

  final TicketHistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final isServed = status == TicketHistoryStatus.served;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isServed
            ? AppColors.successContainer
            : AppColors.dangerContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          isServed ? 'SERVI' : 'ANNULÉ',
          style: TextStyle(
            color: isServed ? AppColors.success : AppColors.danger,
            fontFamily: AppFonts.inter,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
