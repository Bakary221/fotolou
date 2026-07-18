import 'package:fotolou/features/client/domain/entities/salon.dart';
import 'package:fotolou/features/client/domain/repositories/salon_repository.dart';

class InMemorySalonRepository implements SalonRepository {
  static const _salons = [
    Salon(
      id: 'king-barber-1',
      name: 'King Barber',
      location: 'Mermoz, Dakar',
      listImageAsset: 'assets/images/client/king_barber.png',
      heroImageAsset: 'assets/images/client/king_barber_hero.png',
      waitingCount: 15,
      isOpen: true,
    ),
    Salon(
      id: 'king-barber-2',
      name: 'King Barber',
      location: 'Mermoz, Dakar',
      listImageAsset: 'assets/images/client/king_barber.png',
      heroImageAsset: 'assets/images/client/king_barber_hero.png',
      waitingCount: 15,
      isOpen: true,
    ),
    Salon(
      id: 'king-barber-3',
      name: 'King Barber',
      location: 'Mermoz, Dakar',
      listImageAsset: 'assets/images/client/king_barber.png',
      heroImageAsset: 'assets/images/client/king_barber_hero.png',
      waitingCount: 15,
      isOpen: true,
    ),
    Salon(
      id: 'king-barber-4',
      name: 'King Barber',
      location: 'Mermoz, Dakar',
      listImageAsset: 'assets/images/client/king_barber.png',
      heroImageAsset: 'assets/images/client/king_barber_hero.png',
      waitingCount: 15,
      isOpen: true,
    ),
  ];

  @override
  List<Salon> getNearbySalons() => _salons;

  @override
  Salon? getSalonById(String id) {
    for (final salon in _salons) {
      if (salon.id == id) {
        return salon;
      }
    }
    return null;
  }
}
