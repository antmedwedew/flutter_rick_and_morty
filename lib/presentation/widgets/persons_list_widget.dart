import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty/presentation/cubit/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_rick_and_morty/presentation/cubit/person_list_cubit/person_list_state.dart';
import 'package:flutter_rick_and_morty/presentation/widgets/person_card_widget.dart';

class PersonsList extends StatelessWidget {
  final scrollController = ScrollController();

  PersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];
        bool isLoading = false;

        if (state is PersonLoading && state.isFirstFetch) {
          return _loadingIndicator();
        } else if (state is PersonLoading) {
          persons = state.oldPersonsList;
          isLoading = true;
        } else if (state is PersonLoaded) {
          persons = state.personsList;
        } else if (state is PersonError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          );
        }

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < persons.length) {
              return PersonCard(person: persons[index]);
            } else {
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey[400]);
          },
          itemCount: persons.length + (isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        context.read<PersonListCubit>().loadPerson();
      }
    });
  }
}
