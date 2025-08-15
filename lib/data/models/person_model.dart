import 'package:flutter_rick_and_morty/data/models/location_model.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  const PersonModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.img,
    required super.episode,
    required super.created,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: json['origin'] != null
          ? LocationModel.fromJson(json['origin'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      img: json['img'],
      episode: (json['episode'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      created: DateTime.parse(json['created'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'img': img,
      'episode': episode,
      'created': created,
    };
  }
}
