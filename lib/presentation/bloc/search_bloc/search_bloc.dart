import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty/core/error/failure.dart';
import 'package:flutter_rick_and_morty/domain/usecases/search_person.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onSearchPersons);
  }

  Future<void> _onSearchPersons(
    SearchPersons event,
    Emitter<PersonSearchState> emit,
  ) async {
    emit(PersonSearchLoading());

    final failureOrPerson = await searchPerson(
      SearchPersonParams(query: event.personQuery),
    );

    failureOrPerson.fold(
      (failure) =>
          emit(PersonSearchError(message: _mapFailureToMessage(failure))),
      (person) => emit(PersonSearchLoaded(persons: person)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
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
