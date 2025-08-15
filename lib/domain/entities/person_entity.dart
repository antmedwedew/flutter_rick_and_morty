import 'package:equatable/equatable.dart';
import 'package:flutter_rick_and_morty/domain/entities/location_entity.dart';

class PersonEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final LocationEntity? origin;
  final LocationEntity? location;
  final String img;
  final List<String> episode;
  final DateTime created;

  const PersonEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    this.origin,
    this.location,
    required this.img,
    required this.episode,
    required this.created,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    type,
    gender,
    origin,
    location,
    img,
    episode,
    created,
  ];
}
