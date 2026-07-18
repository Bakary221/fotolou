import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarberDashboardController extends Notifier<bool> {
  @override
  bool build() => true;

  void toggleSalonStatus() => state = !state;
}

final barberDashboardControllerProvider =
    NotifierProvider<BarberDashboardController, bool>(
      BarberDashboardController.new,
    );
