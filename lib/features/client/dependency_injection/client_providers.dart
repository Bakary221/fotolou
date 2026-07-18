import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fotolou/features/client/data/repositories/in_memory_salon_repository.dart';
import 'package:fotolou/features/client/domain/entities/salon.dart';
import 'package:fotolou/features/client/domain/repositories/salon_repository.dart';
import 'package:fotolou/features/client/domain/usecases/get_nearby_salons.dart';

final salonRepositoryProvider = Provider<SalonRepository>(
  (ref) => InMemorySalonRepository(),
);

final getNearbySalonsProvider = Provider<GetNearbySalons>(
  (ref) => GetNearbySalons(ref.watch(salonRepositoryProvider)),
);

final nearbySalonsProvider = Provider<List<Salon>>(
  (ref) => ref.watch(getNearbySalonsProvider)(),
);

final salonByIdProvider = Provider.family<Salon?, String>(
  (ref, id) => ref.watch(salonRepositoryProvider).getSalonById(id),
);
