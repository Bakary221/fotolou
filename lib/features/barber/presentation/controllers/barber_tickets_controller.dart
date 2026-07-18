import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BarberTicketView { current, history }

class BarberTicketsController extends Notifier<BarberTicketView> {
  @override
  BarberTicketView build() => BarberTicketView.current;

  void select(BarberTicketView view) => state = view;
}

final barberTicketsControllerProvider =
    NotifierProvider<BarberTicketsController, BarberTicketView>(
      BarberTicketsController.new,
    );
