import 'package:equatable/equatable.dart';

class Salon extends Equatable {
  const Salon({
    required this.id,
    required this.name,
    required this.location,
    required this.listImageAsset,
    required this.heroImageAsset,
    required this.waitingCount,
    required this.isOpen,
  });

  final String id;
  final String name;
  final String location;
  final String listImageAsset;
  final String heroImageAsset;
  final int waitingCount;
  final bool isOpen;

  @override
  List<Object> get props => [
    id,
    name,
    location,
    listImageAsset,
    heroImageAsset,
    waitingCount,
    isOpen,
  ];
}
