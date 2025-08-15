import 'dart:convert';

import 'package:flutter_rick_and_morty/core/error/exception.dart';
import 'package:flutter_rick_and_morty/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalService {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

class PersonLocalServiceImpl implements PersonLocalService {
  final SharedPreferences sharedPreferences;

  PersonLocalServiceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final List<String>? jsonPersonsList = sharedPreferences.getStringList(
      'CACHED_PERSONS_LIST',
    );

    if (jsonPersonsList != null && jsonPersonsList.isNotEmpty) {
      return Future.value(
        jsonPersonsList
            .map((person) => PersonModel.fromJson(json.decode(person)))
            .toList(),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList = persons
        .map((person) => json.encode(person.toJson()))
        .toList();

    sharedPreferences.setStringList('CACHED_PERSONS_LIST', jsonPersonsList);
    return Future.value();
  }
}
