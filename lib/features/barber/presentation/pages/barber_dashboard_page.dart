import 'package:flutter/material.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';

class BarberDashboardPage extends StatelessWidget {
  const BarberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: const Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTopHeader(showLocation: false),
                        SizedBox(height: 45),
                        _WaitingHeroCard(),
                        SizedBox(height: 45),
                        Row(
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
                _BarberBottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaitingHeroCard extends StatelessWidget {
  const _WaitingHeroCard();

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
            const Positioned(
              right: 29,
              top: 44,
              child: Text(
                'Ouvert',
                style: TextStyle(
                  color: Color(0xFF17FE17),
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  height: 20 / 16,
                ),
              ),
            ),
            Positioned(
              right: 25,
              bottom: 58,
              child: Container(
                width: 70,
                height: 30,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
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
            ),
          ],
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

class _BarberBottomNav extends StatelessWidget {
  const _BarberBottomNav();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray100)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 69,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BarberBottomNavItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                isActive: true,
              ),
              _BarberBottomNavItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Mes tickets',
              ),
              _BarberBottomNavItem(icon: Icons.person_outline, label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarberBottomNavItem extends StatelessWidget {
  const _BarberBottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.mutedInk;

    return SizedBox(
      width: 82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}
