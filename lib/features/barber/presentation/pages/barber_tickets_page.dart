import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';

abstract final class BarberTicketsTokens {
  static const pageKey = Key('barber_tickets_page');
  static const currentTabKey = Key('barber_tickets_current_tab');
  static const historyTabKey = Key('barber_tickets_history_tab');
  static const liveListKey = Key('barber_tickets_live_list');
  static const historyListKey = Key('barber_tickets_history_list');
  static const addClientButtonKey = Key('barber_tickets_add_client_button');
}

enum _BarberTicketView { current, history }

class BarberTicketsPage extends StatefulWidget {
  const BarberTicketsPage({super.key});

  @override
  State<BarberTicketsPage> createState() => _BarberTicketsPageState();
}

class _BarberTicketsPageState extends State<BarberTicketsPage> {
  _BarberTicketView _view = _BarberTicketView.current;

  void _selectView(_BarberTicketView view) {
    setState(() {
      _view = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: BarberTicketsTokens.pageKey,
        backgroundColor: AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: AppTopHeader(showLocation: false),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: _BarberTicketTabs(
                                view: _view,
                                onViewChanged: _selectView,
                              ),
                            ),
                            const SizedBox(height: 43),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: _TicketSectionHeader(
                                title: _view == _BarberTicketView.current
                                    ? 'File en direct'
                                    : 'Passages recents',
                              ),
                            ),
                            const SizedBox(height: 22),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  96,
                                ),
                                child: _view == _BarberTicketView.current
                                    ? const _LiveQueueList()
                                    : const _HistoryList(),
                              ),
                            ),
                          ],
                        ),
                        if (_view == _BarberTicketView.current)
                          const Positioned(
                            right: 12,
                            bottom: 20,
                            child: _AddClientButton(),
                          ),
                      ],
                    ),
                  ),
                  const BarberBottomNav(activeIndex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarberTicketTabs extends StatelessWidget {
  const _BarberTicketTabs({required this.view, required this.onViewChanged});

  final _BarberTicketView view;
  final ValueChanged<_BarberTicketView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _BarberTicketTab(
              key: BarberTicketsTokens.currentTabKey,
              label: 'Actuel',
              isActive: view == _BarberTicketView.current,
              onTap: () => onViewChanged(_BarberTicketView.current),
            ),
          ),
          Expanded(
            child: _BarberTicketTab(
              key: BarberTicketsTokens.historyTabKey,
              label: 'Historiques',
              isActive: view == _BarberTicketView.history,
              onTap: () => onViewChanged(_BarberTicketView.history),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarberTicketTab extends StatelessWidget {
  const _BarberTicketTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isActive ? AppColors.secondary : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.gray600,
                fontFamily: 'Inter',
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
              color: Color(0xFF191C1E),
              fontFamily: 'Inter',
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
            fontFamily: 'Inter',
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
        border: Border.all(color: const Color(0xFFC3C5D9)),
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
                        color: Color(0xFF191C1E),
                        fontFamily: 'Inter',
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
                        color: Color(0xFF434656),
                        fontFamily: 'Inter',
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
                  foregroundColor: Color(0xFF005E32),
                  borderColor: Color(0xFF005E32),
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
        color: const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: AppColors.primary,
          fontFamily: 'Inter',
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
        color: isCurrent ? const Color(0xFF007943) : const Color(0xFFECEEF0),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          isCurrent ? 'En cours' : 'En Attente',
          style: TextStyle(
            color: isCurrent ? AppColors.white : const Color(0xFF484C52),
            fontFamily: 'Inter',
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
            fontFamily: 'Inter',
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
          side: const BorderSide(color: Color(0xFFC3C5D9)),
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
    _HistoryItem(
      initials: 'AD',
      name: 'Awa Diop',
      date: 'Hier, 14:30',
      status: _HistoryStatus.served,
    ),
    _HistoryItem(
      initials: 'CF',
      name: 'Cheikh Fall',
      date: '12 Oct, 10:00',
      status: _HistoryStatus.cancelled,
    ),
    _HistoryItem(
      initials: 'MK',
      name: 'Moussa Kane',
      date: '11 Oct, 16:15',
      status: _HistoryStatus.served,
    ),
    _HistoryItem(
      initials: 'IS',
      name: 'Ibrahima Sow',
      date: '11 Oct, 09:45',
      status: _HistoryStatus.served,
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
            child: _HistoryCard(item: item),
          ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final _HistoryItem item;

  @override
  Widget build(BuildContext context) {
    final isServed = item.status == _HistoryStatus.served;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray100),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _HistoryAvatar(initials: item.initials, isServed: isServed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 24 / 16,
                  ),
                ),
                Text(
                  item.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.gray600,
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _HistoryStatusBadge(status: item.status),
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
        color: isServed ? const Color(0xFFEFF6FF) : AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: isServed ? AppColors.secondary : AppColors.gray600,
          fontFamily: 'Inter',
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

  final _HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final isServed = status == _HistoryStatus.served;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isServed ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          isServed ? 'SERVI' : 'ANNULÉ',
          style: TextStyle(
            color: isServed ? AppColors.success : AppColors.danger,
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 15 / 10,
          ),
        ),
      ),
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

class _HistoryItem {
  const _HistoryItem({
    required this.initials,
    required this.name,
    required this.date,
    required this.status,
  });

  final String initials;
  final String name;
  final String date;
  final _HistoryStatus status;
}

enum _HistoryStatus { served, cancelled }
