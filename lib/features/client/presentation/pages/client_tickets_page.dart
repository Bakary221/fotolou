import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/features/client/presentation/controllers/client_tickets_controller.dart';
import 'package:fotolou/features/client/presentation/widgets/client_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_segmented_control.dart';
import 'package:fotolou/shared/widgets/app_status_badge.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';
import 'package:fotolou/shared/widgets/ticket_history_card.dart';

abstract final class ClientTicketsTokens {
  static const pageKey = Key('client_tickets_page');
  static const currentTabKey = Key('client_tickets_current_tab');
  static const historyTabKey = Key('client_tickets_history_tab');
  static const historyListKey = Key('client_tickets_history_list');
  static const progressKey = Key('client_tickets_progress');
}

class ClientTicketsPage extends ConsumerWidget {
  const ClientTicketsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(clientTicketsControllerProvider);
    return RolePageScaffold(
      key: ClientTicketsTokens.pageKey,
      bottomNavigationBar: const ClientBottomNav(activeIndex: 1),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: AppTopHeader(showLocation: false),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 44),
              child: _TicketsContent(
                view: view,
                onViewChanged: ref
                    .read(clientTicketsControllerProvider.notifier)
                    .select,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketsContent extends StatelessWidget {
  const _TicketsContent({required this.view, required this.onViewChanged});

  final ClientTicketView view;
  final ValueChanged<ClientTicketView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSegmentedControl<ClientTicketView>(
          selectedValue: view,
          onChanged: onViewChanged,
          segments: const [
            AppSegment(
              key: ClientTicketsTokens.currentTabKey,
              value: ClientTicketView.current,
              label: 'Actuel',
            ),
            AppSegment(
              key: ClientTicketsTokens.historyTabKey,
              value: ClientTicketView.history,
              label: 'Historiques',
            ),
          ],
        ),
        const SizedBox(height: 38),
        if (view == ClientTicketView.current)
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
            fontFamily: AppFonts.inter,
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
            fontFamily: AppFonts.inter,
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
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            height: 35 / 20,
          ),
        ),
      ],
    );
  }
}

class _HistoryTicketContent extends StatelessWidget {
  const _HistoryTicketContent();

  static const _items = [
    TicketHistoryEntry(
      initials: 'K',
      name: 'KingBarber',
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
      key: ClientTicketsTokens.historyListKey,
      children: [
        const _HistoryHeader(),
        const SizedBox(height: 38),
        ..._items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TicketHistoryCard(entry: item),
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
            'Passages récents',
            style: TextStyle(
              color: AppColors.textSection,
              fontFamily: AppFonts.inter,
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
              color: AppColors.black,
              fontFamily: AppFonts.inter,
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
      ..color = AppColors.progressTrack
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
                fontFamily: AppFonts.inter,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _TicketStatCard(title: 'STATUT', child: AppStatusBadge.open()),
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
            color: AppColors.shadowBlack07,
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
              color: AppColors.textMetric,
              fontFamily: AppFonts.inter,
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
