import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/features/client/presentation/widgets/client_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';

abstract final class ClientTicketsTokens {
  static const pageKey = Key('client_tickets_page');
  static const currentTabKey = Key('client_tickets_current_tab');
  static const historyTabKey = Key('client_tickets_history_tab');
  static const historyListKey = Key('client_tickets_history_list');
  static const progressKey = Key('client_tickets_progress');
}

enum _TicketView { current, history }

class ClientTicketsPage extends StatefulWidget {
  const ClientTicketsPage({super.key});

  @override
  State<ClientTicketsPage> createState() => _ClientTicketsPageState();
}

class _ClientTicketsPageState extends State<ClientTicketsPage> {
  _TicketView _view = _TicketView.current;

  void _selectView(_TicketView view) {
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
        key: ClientTicketsTokens.pageKey,
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 36, 16, 44),
                      child: _TicketsContent(
                        view: _view,
                        onViewChanged: _selectView,
                      ),
                    ),
                  ),
                  const ClientBottomNav(activeIndex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketsContent extends StatelessWidget {
  const _TicketsContent({required this.view, required this.onViewChanged});

  final _TicketView view;
  final ValueChanged<_TicketView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TicketTabs(view: view, onViewChanged: onViewChanged),
        const SizedBox(height: 38),
        if (view == _TicketView.current)
          const _CurrentTicketContent()
        else
          const _HistoryTicketContent(),
      ],
    );
  }
}

class _CurrentTicketContent extends StatelessWidget {
  const _CurrentTicketContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'M O N  T O U R',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 20 / 20,
            letterSpacing: 4,
          ),
        ),
        SizedBox(height: 26),
        Text(
          'Tu es le numéro',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.ink,
            fontFamily: 'Inter',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 40 / 36,
          ),
        ),
        SizedBox(height: 28),
        _QueueProgress(),
        SizedBox(height: 32),
        _TicketStats(),
        SizedBox(height: 50),
        Text(
          'Quitter la file',
          style: TextStyle(
            color: AppColors.danger,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            height: 35 / 20,
          ),
        ),
      ],
    );
  }
}

class _TicketTabs extends StatelessWidget {
  const _TicketTabs({required this.view, required this.onViewChanged});

  final _TicketView view;
  final ValueChanged<_TicketView> onViewChanged;

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
            child: _TicketTab(
              key: ClientTicketsTokens.currentTabKey,
              label: 'Actuel',
              isActive: view == _TicketView.current,
              onTap: () => onViewChanged(_TicketView.current),
            ),
          ),
          Expanded(
            child: _TicketTab(
              key: ClientTicketsTokens.historyTabKey,
              label: 'Historiques',
              isActive: view == _TicketView.history,
              onTap: () => onViewChanged(_TicketView.history),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketTab extends StatelessWidget {
  const _TicketTab({
    required this.label,
    required this.onTap,
    this.isActive = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

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

class _HistoryTicketContent extends StatelessWidget {
  const _HistoryTicketContent();

  static const _items = [
    _HistoryItem(
      initials: 'K',
      name: 'KingBarber',
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
      key: ClientTicketsTokens.historyListKey,
      children: [
        const _HistoryHeader(),
        const SizedBox(height: 38),
        ..._items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _HistoryCard(item: item),
          ),
        ),
      ],
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Passages recents',
            style: TextStyle(
              color: Color(0xFF191C1E),
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
            ),
          ),
        ),
        Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 18),
        SizedBox(width: 4),
        Text(
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

class _QueueProgress extends StatelessWidget {
  const _QueueProgress();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      key: ClientTicketsTokens.progressKey,
      dimension: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(300),
            painter: _QueueProgressPainter(progress: 0.76),
          ),
          Text(
            '6',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Inter',
              fontSize: 128,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueProgressPainter extends CustomPainter {
  const _QueueProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final trackPaint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.butt;
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      rect.deflate(7.5),
      -math.pi / 2,
      math.pi * 2,
      false,
      trackPaint,
    );
    canvas.drawArc(
      rect.deflate(7.5),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _QueueProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TicketStats extends StatelessWidget {
  const _TicketStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _TicketStatCard(
            title: 'NUMERO EN COURS',
            child: Text(
              '2',
              style: TextStyle(
                color: AppColors.slate800,
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _TicketStatCard(title: 'STATUT', child: _OpenStatusBadge()),
        ),
      ],
    );
  }
}

class _TicketStatCard extends StatelessWidget {
  const _TicketStatCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(11, 13, 11, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.slate800),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF484C52),
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Spacer(),
          child,
          const Spacer(),
        ],
      ),
    );
  }
}

class _OpenStatusBadge extends StatelessWidget {
  const _OpenStatusBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            'Ouvert',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 16 / 12,
            ),
          ),
        ),
      ),
    );
  }
}
