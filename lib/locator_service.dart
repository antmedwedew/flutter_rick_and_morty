import 'package:flutter_rick_and_morty/core/platform/network_info.dart';
import 'package:flutter_rick_and_morty/data/repositories/person_repository_iml.dart';
import 'package:flutter_rick_and_morty/data/services/person_local_service.dart';
import 'package:flutter_rick_and_morty/data/services/person_service.dart';
import 'package:flutter_rick_and_morty/domain/repositories/person_repository.dart';
import 'package:flutter_rick_and_morty/domain/usecases/get_all_persons.dart';
import 'package:flutter_rick_and_morty/domain/usecases/search_person.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_rick_and_morty/presentation/cubit/person_list_cubit/person_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BloC / Cubit
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryIml(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton<PersonService>(
    () => PersonServiceImpl(client: http.Client()),
  );
  sl.registerLazySingleton<PersonLocalService>(
    () => PersonLocalServiceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
