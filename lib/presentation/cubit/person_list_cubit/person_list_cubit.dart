import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty/core/error/failure.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty/domain/usecases/get_all_persons.dart';
import 'package:flutter_rick_and_morty/presentation/cubit/person_list_cubit/person_list_state.dart';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final PersonState currentState = state;
    var oldPerson = <PersonEntity>[];

    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPersonsList: oldPerson, isFirstFetch: page == 1));

    final faiureOrPerson = await getAllPersons(PagePersonParams(page: page));

    faiureOrPerson.fold(
      (failure) => emit(PersonError(message: _mapFailuretoMessage(failure))),
      (person) {
        page++;
        final personsList = (state as PersonLoading).oldPersonsList;
        personsList.addAll(person);
        emit(PersonLoaded(personsList: personsList));
      },
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
