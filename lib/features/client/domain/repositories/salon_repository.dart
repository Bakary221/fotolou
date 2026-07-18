import 'package:fotolou/features/client/domain/entities/salon.dart';

abstract interface class SalonRepository {
  List<Salon> getNearbySalons();

  Salon? getSalonById(String id);
}
