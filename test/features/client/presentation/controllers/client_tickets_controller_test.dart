import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fotolou/features/client/presentation/controllers/client_tickets_controller.dart';

void main() {
  test('selects the client ticket view', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(clientTicketsControllerProvider),
      ClientTicketView.current,
    );

    container
        .read(clientTicketsControllerProvider.notifier)
        .select(ClientTicketView.history);

    expect(
      container.read(clientTicketsControllerProvider),
      ClientTicketView.history,
    );
  });
}
