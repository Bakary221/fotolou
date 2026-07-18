import 'package:fotolou/features/client/domain/entities/salon.dart';
import 'package:fotolou/features/client/domain/repositories/salon_repository.dart';

class GetNearbySalons {
  const GetNearbySalons(this._repository);

  final SalonRepository _repository;

  List<Salon> call() => _repository.getNearbySalons();
}
