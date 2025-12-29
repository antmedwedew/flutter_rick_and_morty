import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty/presentation/bloc/search_bloc/search_state.dart';
import 'package:flutter_rick_and_morty/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({searchFieldLabel = 'Поиск персонажей...'});

  final _suggestions = ['Rick', 'Morty', 'Summer'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_outlined),
      tooltip: 'Назад',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    BlocProvider.of<PersonSearchBloc>(
      context,
      listen: false,
    ).add(SearchPersons(personQuery: query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonSearchLoaded) {
          final persons = state.persons;

          if (persons.isEmpty) {
            return _showErrorText('Нет персонажей по указанному названию');
          }

          return ListView.builder(
            itemBuilder: (context, int index) {
              PersonEntity result = persons[index];

              return SearchResult(personResult: result);
            },
            itemCount: persons.isNotEmpty ? persons.length : 0,
          );
        } else if (state is PersonSearchError) {
          return _showErrorText(state.message);
        } else {
          return Center(child: Icon(Icons.now_wallpaper));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, int index) {
        if (query.isNotEmpty) {
          return Container();
        }

        return GestureDetector(
          onTap: () {
            query = _suggestions[index];
          },
          child: Text(
            _suggestions[index],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        );
      },
      separatorBuilder: (context, int index) {
        if (query.isNotEmpty) {
          return Container();
        }

        return Divider();
      },
      itemCount: _suggestions.length,
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
