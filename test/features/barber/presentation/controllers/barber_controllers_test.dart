import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/features/barber/presentation/controllers/barber_dashboard_controller.dart';
import 'package:fotolou/features/barber/presentation/controllers/barber_tickets_controller.dart';

void main() {
  test('toggles salon availability', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(barberDashboardControllerProvider), isTrue);

    container
        .read(barberDashboardControllerProvider.notifier)
        .toggleSalonStatus();

    expect(container.read(barberDashboardControllerProvider), isFalse);
  });

  test('selects the barber ticket view', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(barberTicketsControllerProvider),
      BarberTicketView.current,
    );

    container
        .read(barberTicketsControllerProvider.notifier)
        .select(BarberTicketView.history);

    expect(
      container.read(barberTicketsControllerProvider),
      BarberTicketView.history,
    );
  });
}
