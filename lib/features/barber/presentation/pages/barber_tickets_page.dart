import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/features/barber/presentation/controllers/barber_tickets_controller.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_segmented_control.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';
import 'package:fotolou/shared/widgets/ticket_history_card.dart';

abstract final class BarberTicketsTokens {
  static const pageKey = Key('barber_tickets_page');
  static const currentTabKey = Key('barber_tickets_current_tab');
  static const historyTabKey = Key('barber_tickets_history_tab');
  static const liveListKey = Key('barber_tickets_live_list');
  static const historyListKey = Key('barber_tickets_history_list');
  static const addClientButtonKey = Key('barber_tickets_add_client_button');
}

class BarberTicketsPage extends ConsumerWidget {
  const BarberTicketsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(barberTicketsControllerProvider);
    return RolePageScaffold(
      key: BarberTicketsTokens.pageKey,
      bottomNavigationBar: const BarberBottomNav(activeIndex: 1),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.pageTop,
              AppSpacing.pageHorizontal,
              0,
            ),
            child: AppTopHeader(showLocation: false),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        40,
                        AppSpacing.pageHorizontal,
                        0,
                      ),
                      child: AppSegmentedControl<BarberTicketView>(
                        selectedValue: view,
                        onChanged: ref
                            .read(barberTicketsControllerProvider.notifier)
                            .select,
                        segments: const [
                          AppSegment(
                            key: BarberTicketsTokens.currentTabKey,
                            value: BarberTicketView.current,
                            label: 'Actuel',
                          ),
                          AppSegment(
                            key: BarberTicketsTokens.historyTabKey,
                            value: BarberTicketView.history,
                            label: 'Historiques',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 43),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageHorizontal,
                      ),
                      child: _TicketSectionHeader(
                        title: view == BarberTicketView.current
                            ? 'File en direct'
                            : 'Passages récents',
                      ),
                    ),
                    const SizedBox(height: 22),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          0,
                          AppSpacing.pageHorizontal,
                          96,
                        ),
                        child: view == BarberTicketView.current
                            ? const _LiveQueueList()
                            : const _HistoryList(),
                      ),
                    ),
                  ],
                ),
                if (view == BarberTicketView.current)
                  const Positioned(
                    right: 12,
                    bottom: 20,
                    child: _AddClientButton(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketSectionHeader extends StatelessWidget {
  const _TicketSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSection,
              fontFamily: AppFonts.inter,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
            ),
          ),
        ),
        const Icon(
          Icons.filter_list_rounded,
          color: AppColors.primary,
          size: 18,
        ),
        const SizedBox(width: 4),
        const Text(
          'Filtrer',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: AppFonts.inter,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 16 / 14,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }
}

class _LiveQueueList extends StatelessWidget {
  const _LiveQueueList();

  static const _items = [
    _LiveQueueItem(
      number: '01',
      name: 'Amadou Koulibaly',
      phone: '+221 77 862 70 52',
      status: _LiveQueueStatus.current,
    ),
    _LiveQueueItem(
      number: '02',
      name: 'Fallou Gaye',
      phone: '+221 77 111 11 11',
      status: _LiveQueueStatus.waiting,
    ),
    _LiveQueueItem(
      number: '03',
      name: 'Amy Diop',
      phone: '+221 77 111 11 11',
      status: _LiveQueueStatus.waiting,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: BarberTicketsTokens.liveListKey,
      children: [
        for (final item in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: _LiveQueueCard(item: item),
          ),
      ],
    );
  }
}

class _LiveQueueCard extends StatelessWidget {
  const _LiveQueueCard({required this.item});

  final _LiveQueueItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.queueBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QueueNumberBadge(number: item.number),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSection,
                        fontFamily: AppFonts.inter,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 28 / 18,
                      ),
                    ),
                    Text(
                      item.phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textQueue,
                        fontFamily: AppFonts.inter,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _LiveStatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _QueueActionButton(
                  label: 'Sauter',
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  borderColor: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QueueActionButton(
                  label: 'Servi',
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.actionGreen,
                  borderColor: AppColors.actionGreen,
                ),
              ),
              SizedBox(width: 12),
              _MoreButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _QueueNumberBadge extends StatelessWidget {
  const _QueueNumberBadge({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.neutralSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: AppColors.primary,
          fontFamily: AppFonts.inter,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
        ),
      ),
    );
  }
}

class _LiveStatusBadge extends StatelessWidget {
  const _LiveStatusBadge({required this.status});

  final _LiveQueueStatus status;

  @override
  Widget build(BuildContext context) {
    final isCurrent = status == _LiveQueueStatus.current;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.currentGreen : AppColors.neutralSurface,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          isCurrent ? 'En cours' : 'En Attente',
          style: TextStyle(
            color: isCurrent ? AppColors.white : AppColors.textMetric,
            fontFamily: AppFonts.inter,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
      ),
    );
  }
}

class _QueueActionButton extends StatelessWidget {
  const _QueueActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.inter,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 16 / 14,
            letterSpacing: 0.7,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 42,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.queueBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(Icons.more_vert_rounded, size: 20),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList();

  static const _items = [
    TicketHistoryEntry(
      initials: 'AD',
      name: 'Awa Diop',
      date: 'Hier, 14:30',
      status: TicketHistoryStatus.served,
    ),
    TicketHistoryEntry(
      initials: 'CF',
      name: 'Cheikh Fall',
      date: '12 Oct, 10:00',
      status: TicketHistoryStatus.cancelled,
    ),
    TicketHistoryEntry(
      initials: 'MK',
      name: 'Moussa Kane',
      date: '11 Oct, 16:15',
      status: TicketHistoryStatus.served,
    ),
    TicketHistoryEntry(
      initials: 'IS',
      name: 'Ibrahima Sow',
      date: '11 Oct, 09:45',
      status: TicketHistoryStatus.served,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: BarberTicketsTokens.historyListKey,
      children: [
        for (final item in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TicketHistoryCard(entry: item),
          ),
      ],
    );
  }
}

class _AddClientButton extends StatelessWidget {
  const _AddClientButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      key: BarberTicketsTokens.addClientButtonKey,
      dimension: 56,
      child: FloatingActionButton(
        heroTag: 'barber_add_client',
        elevation: 8,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.person_add_alt_1_rounded, size: 24),
      ),
    );
  }
}

class _LiveQueueItem {
  const _LiveQueueItem({
    required this.number,
    required this.name,
    required this.phone,
    required this.status,
  });

  final String number;
  final String name;
  final String phone;
  final _LiveQueueStatus status;
}

enum _LiveQueueStatus { current, waiting }
