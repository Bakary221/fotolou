import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotolou/app/theme/app_colors.dart';
import 'package:fotolou/features/client/presentation/pages/client_tickets_page.dart';
import 'package:fotolou/shared/widgets/app_top_header.dart';

abstract final class ClientSalonDetailTokens {
  static const backButtonKey = Key('client_salon_detail_back_button');
  static const heroKey = Key('client_salon_detail_hero');
  static const ticketButtonKey = Key('client_salon_detail_ticket_button');
  static const heroAsset = 'assets/images/client/king_barber_hero.png';
  static const fallbackHeroAsset = 'assets/images/client/king_barber.png';
}

class ClientSalonDetailPage extends StatelessWidget {
  const ClientSalonDetailPage({super.key});

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
        backgroundColor: AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: AppTopHeader(showLocation: false),
                  ),
                  Expanded(
                    child: SingleChildScrollView(child: _SalonDetailContent()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SalonDetailContent extends StatelessWidget {
  const _SalonDetailContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SalonHero(),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _SalonTitle(),
        ),
        SizedBox(height: 26),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _ContactOptions(),
        ),
        SizedBox(height: 45),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _SalonStats(),
        ),
        SizedBox(height: 65),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _TicketButton(),
        ),
        SizedBox(height: 49),
      ],
    );
  }
}

class _SalonHero extends StatelessWidget {
  const _SalonHero();

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
            ClientSalonDetailTokens.heroAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                ClientSalonDetailTokens.fallbackHeroAsset,
                fit: BoxFit.cover,
              );
            },
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  AppColors.transparent,
                  Color(0x66000000),
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 48,
            child: _BackButton(onTap: () => Navigator.of(context).maybePop()),
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
  const _SalonTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'King Barber',
          style: TextStyle(
            color: AppColors.ink,
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 24 / 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Mermoz, Dakar',
          style: TextStyle(
            color: Color(0xFF757575),
            fontFamily: 'Inter',
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
              color: const Color(0xFFE6EDFA),
              border: Border.all(color: const Color(0xFFE5E5E5)),
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
              color: Color(0xA6000000),
              fontFamily: 'Inter',
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
                color: Colors.black,
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(width: 23),
        Expanded(
          child: _StatCard(title: 'STATUT', child: _OpenStatusBadge()),
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
              color: Color(0xFF484C52),
              fontFamily: 'Poppins',
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
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const ClientTicketsPage()),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Prendre mon ticket',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'Poppins',
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
