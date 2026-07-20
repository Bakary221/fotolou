import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/app/theme/app_spacing.dart';
import 'package:fotolou/features/barber/presentation/controllers/barber_dashboard_controller.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:fotolou/shared/widgets/role_page_scaffold.dart';

abstract final class BarberDashboardTokens {
  static const statusToggleKey = Key('barber_dashboard_status_toggle');
}

class BarberDashboardPage extends ConsumerWidget {
  const BarberDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSalonOpen = ref.watch(barberDashboardControllerProvider);
    return RolePageScaffold(
      bottomNavigationBar: const BarberBottomNav(activeIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.pageTop,
          AppSpacing.pageHorizontal,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopHeader(showLocation: false),
            const SizedBox(height: 45),
            _WaitingHeroCard(
              isSalonOpen: isSalonOpen,
              onStatusTap: ref
                  .read(barberDashboardControllerProvider.notifier)
                  .toggleSalonStatus,
            ),
            const SizedBox(height: 45),
            const Row(
              children: [
                Expanded(
                  child: _BarberMetricCard(label: 'EN ATTENTE', value: '5'),
                ),
                SizedBox(width: 22),
                Expanded(
                  child: _BarberMetricCard(label: 'SERVIS', value: '25'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WaitingHeroCard extends StatelessWidget {
  const _WaitingHeroCard({
    required this.isSalonOpen,
    required this.onStatusTap,
  });

  final bool isSalonOpen;
  final VoidCallback onStatusTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 195,
        color: AppColors.primary,
        child: Stack(
          children: [
            Positioned(
              right: 40,
              top: -69,
              child: Container(
                width: 202,
                height: 138,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.24),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.elliptical(101, 69),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 32,
              top: 48,
              child: Text(
                'CLIENTS EN ATTENTE',
                style: TextStyle(
                  color: AppColors.accent,
                  fontFamily: AppFonts.poppins,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
            const Positioned(
              left: 32,
              bottom: 50,
              child: Text(
                '12',
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: AppFonts.poppins,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 20 / 48,
                ),
              ),
            ),
            const Positioned(
              left: 106,
              bottom: 62,
              child: Text(
                '↑ +18% vs hier',
                style: TextStyle(
                  color: AppColors.accent,
                  fontFamily: AppFonts.poppins,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 20 / 16,
                ),
              ),
            ),
            Positioned(
              right: 25,
              top: 44,
              child: _SalonStatusToggle(
                isOpen: isSalonOpen,
                onTap: onStatusTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonStatusToggle extends StatelessWidget {
  const _SalonStatusToggle({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = isOpen ? AppColors.toggleGreen : AppColors.danger;
    final labelColor = isOpen
        ? AppColors.toggleLabelGreen
        : AppColors.toggleLabelRed;

    return Semantics(
      button: true,
      label: isOpen ? 'Fermer le salon' : 'Ouvrir le salon',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: SizedBox(
          width: 78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  isOpen ? 'Ouvert' : 'Fermé',
                  style: TextStyle(
                    color: labelColor,
                    fontFamily: AppFonts.inter,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    height: 20 / 16,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AnimatedContainer(
                key: BarberDashboardTokens.statusToggleKey,
                duration: const Duration(milliseconds: 180),
                width: 70,
                height: 30,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: isOpen
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 27,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowBlack10,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarberMetricCard extends StatelessWidget {
  const _BarberMetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSoft),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMetric,
              fontFamily: AppFonts.inter,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontFamily: AppFonts.poppins,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
