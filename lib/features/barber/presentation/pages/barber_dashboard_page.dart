import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/features/barber/presentation/widgets/barber_bottom_nav.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';

abstract final class BarberDashboardTokens {
  static const statusToggleKey = Key('barber_dashboard_status_toggle');
}

class BarberDashboardPage extends StatefulWidget {
  const BarberDashboardPage({super.key});

  @override
  State<BarberDashboardPage> createState() => _BarberDashboardPageState();
}

class _BarberDashboardPageState extends State<BarberDashboardPage> {
  var _isSalonOpen = true;

  void _toggleSalonStatus() {
    setState(() {
      _isSalonOpen = !_isSalonOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppTopHeader(showLocation: false),
                        const SizedBox(height: 45),
                        _WaitingHeroCard(
                          isSalonOpen: _isSalonOpen,
                          onStatusTap: _toggleSalonStatus,
                        ),
                        const SizedBox(height: 45),
                        const Row(
                          children: [
                            Expanded(
                              child: _BarberMetricCard(
                                label: 'EN ATTENTE',
                                value: '5',
                              ),
                            ),
                            SizedBox(width: 22),
                            Expanded(
                              child: _BarberMetricCard(
                                label: 'SERVIS',
                                value: '25',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const BarberBottomNav(activeIndex: 0),
              ],
            ),
          ),
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
                  fontFamily: 'Poppins',
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
                  fontFamily: 'Poppins',
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
                  fontFamily: 'Poppins',
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
    final statusColor = isOpen ? const Color(0xFF22C55E) : AppColors.danger;
    final labelColor = isOpen
        ? const Color(0xFF17FE17)
        : const Color(0xFFFCA5A5);

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
                    fontFamily: 'Inter',
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
                          color: Color(0x1A000000),
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
        border: Border.all(color: const Color(0xFF808080)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF484C52),
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
