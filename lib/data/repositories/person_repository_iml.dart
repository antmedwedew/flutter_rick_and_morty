import 'package:dartz/dartz.dart';
import 'package:flutter_rick_and_morty/core/error/exception.dart';
import 'package:flutter_rick_and_morty/core/error/failure.dart';
import 'package:flutter_rick_and_morty/core/platform/network_info.dart';
import 'package:flutter_rick_and_morty/data/models/person_model.dart';
import 'package:flutter_rick_and_morty/data/services/person_local_service.dart';
import 'package:flutter_rick_and_morty/data/services/person_service.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty/domain/repositories/person_repository.dart';

class PersonRepositoryIml implements PersonRepository {
  final PersonService remoteDataSource;
  final PersonLocalService localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryIml({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return _getPersons(() {
      return remoteDataSource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return _getPersons(() {
      return remoteDataSource.searchPerson(query);
    });
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
    Future<List<PersonModel>> Function() getPerson,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPerson();
        localDataSource.personsToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final locationPerson = await localDataSource.getLastPersonsFromCache();
        return Right(locationPerson);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
