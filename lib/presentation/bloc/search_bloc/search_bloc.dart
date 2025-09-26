import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty/core/error/failure.dart';
import 'package:flutter_rick_and_morty/domain/usecases/search_person.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty());

  Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
    if (event is SearchPersons) {
      yield* _mapFetchPersonsToState(event.personQuery);
    }
  }

  Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
    yield PersonSearchLoading();

    final failureOrPerson = await searchPerson(
      SearchPersonParams(query: personQuery),
    );

    yield failureOrPerson.fold(
      (failure) => PersonSearchError(message: _mapFailuretoMessage(failure)),
      (persons) => PersonSearchLoaded(persons: persons),
    );
  }

  String _mapFailuretoMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error';
      case CacheFailure _:
        return 'Cache error';
      default:
        return 'Error';
    }
  }
}
