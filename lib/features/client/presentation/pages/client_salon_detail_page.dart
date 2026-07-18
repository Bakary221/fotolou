import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/app/routes/app_routes.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/app/theme/app_fonts.dart';
import 'package:fotolou/features/client/dependency_injection/client_providers.dart';
import 'package:fotolou/features/client/domain/entities/salon.dart';
import 'package:fotolou/shared/widgets/app_page_scaffold.dart';
import 'package:fotolou/shared/widgets/app_status_badge.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';
import 'package:go_router/go_router.dart';

abstract final class ClientSalonDetailTokens {
  static const backButtonKey = Key('client_salon_detail_back_button');
  static const heroKey = Key('client_salon_detail_hero');
  static const ticketButtonKey = Key('client_salon_detail_ticket_button');
}

class ClientSalonDetailPage extends ConsumerWidget {
  const ClientSalonDetailPage({this.salonId, super.key});

  final String? salonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbySalons = ref.watch(nearbySalonsProvider);
    final salon = salonId == null
        ? nearbySalons.first
        : ref.watch(salonByIdProvider(salonId!)) ?? nearbySalons.first;

    return AppPageScaffold(
      body: SingleChildScrollView(child: _SalonDetailContent(salon: salon)),
    );
  }
}

class _SalonDetailContent extends StatelessWidget {
  const _SalonDetailContent({required this.salon});

  final Salon salon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SalonHero(salon: salon),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _SalonTitle(salon: salon),
        ),
        const SizedBox(height: 26),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _ContactOptions(),
        ),
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SalonStats(),
        ),
        const SizedBox(height: 65),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _TicketButton(),
        ),
        const SizedBox(height: 49),
      ],
    );
  }
}

class _SalonHero extends StatelessWidget {
  const _SalonHero({required this.salon});

  final Salon salon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ClientSalonDetailTokens.heroKey,
      height: 350,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            salon.heroImageAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(salon.listImageAsset, fit: BoxFit.cover);
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.imageOverlay,
                  AppColors.transparent,
                  AppColors.imageOverlay,
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 48,
            child: _BackButton(onTap: () => _goBack(context)),
          ),
          const Positioned(
            left: 16,
            right: 16,
            top: 46,
            child: AppTopHeader(showLocation: false),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final isActive = index == 1;

                return Container(
                  width: isActive ? 8 : 6,
                  height: isActive ? 8 : 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoute.clientHome.name);
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Retour',
      child: Material(
        color: AppColors.white.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        child: InkWell(
          key: ClientSalonDetailTokens.backButtonKey,
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox.square(
            dimension: 44,
            child: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.ink,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class _SalonTitle extends StatelessWidget {
  const _SalonTitle({required this.salon});

  final Salon salon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          salon.name,
          style: const TextStyle(
            color: AppColors.ink,
            fontFamily: AppFonts.inter,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 24 / 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          salon.location,
          style: const TextStyle(
            color: AppColors.textNeutral,
            fontFamily: AppFonts.inter,
            fontSize: 14,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }
}

class _ContactOptions extends StatelessWidget {
  const _ContactOptions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ContactOption(icon: Icons.language_rounded, label: 'Site Web'),
        _ContactOption(icon: Icons.phone_in_talk_rounded, label: 'Appeler'),
        _ContactOption(icon: Icons.navigation_rounded, label: 'Direction'),
        _ContactOption(icon: Icons.share_rounded, label: 'Partager'),
      ],
    );
  }
}

class _ContactOption extends StatelessWidget {
  const _ContactOption({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 69,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.blueSurface,
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(16.949),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textOverlay,
              fontFamily: AppFonts.inter,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SalonStats extends StatelessWidget {
  const _SalonStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'P E R S O N N E S',
            child: Text(
              '5',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.inter,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: 23),
        Expanded(
          child: _StatCard(title: 'STATUT', child: AppStatusBadge.open()),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(11, 12, 11, 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.slate800),
        borderRadius: BorderRadius.circular(20),
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
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              fontWeight: FontWeight.w400,
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

class _TicketButton extends StatelessWidget {
  const _TicketButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: ClientSalonDetailTokens.ticketButtonKey,
      width: double.infinity,
      height: 73,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBlack05,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              context.goNamed(AppRoute.clientTickets.name);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Prendre mon ticket',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontFamily: AppFonts.poppins,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                  ),
                ),
                SizedBox(width: 22),
                Icon(Icons.arrow_forward, color: AppColors.ink, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
