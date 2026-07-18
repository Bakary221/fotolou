import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ClientTicketView { current, history }

class ClientTicketsController extends Notifier<ClientTicketView> {
  @override
  ClientTicketView build() => ClientTicketView.current;

  void select(ClientTicketView view) => state = view;
}

final clientTicketsControllerProvider =
    NotifierProvider<ClientTicketsController, ClientTicketView>(
      ClientTicketsController.new,
    );
