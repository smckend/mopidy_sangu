import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_listview/grouped_listview.dart';
import 'package:sangu/bloc/search_bloc/bloc.dart';
import 'package:sangu/widget/backend_icon.dart';
import 'package:sangu_websocket/sangu_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SanguSearchWidget extends SearchDelegate<Track> {
  final String _storageKey = "queryHistory";
  var _appData = SharedPreferences.getInstance();

  SanguSearchWidget({
    String hintText = "Search for track",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            showResults(context);
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Container(
        color: Theme.of(context).backgroundColor,
        alignment: Alignment.center,
        child: Text(
          "Search term must be longer than two letters.",
          style: Theme.of(context).textTheme.headline4,
        ),
      );
    }

    query = query.trim();

    _appData.then((appData) {
      if (appData.containsKey(_storageKey)) {
        List querySuggestions = appData.getStringList(_storageKey);
        if (querySuggestions.contains(query)) querySuggestions.remove(query);
        if (querySuggestions.length >= 5) querySuggestions.removeLast();
        querySuggestions.insert(0, query);
        appData.setStringList(_storageKey, querySuggestions);
      } else {
        appData.setStringList(_storageKey, [query]);
      }
    });

    BlocProvider.of<SearchBloc>(context)
        .add(Search(query: {"any": query.split(" ")}));

    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
      if (state is! SearchResultsReady) {
        return Container(
          color: Theme.of(context).backgroundColor,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      } else {
        List<SearchResult> searchResults =
            BlocProvider.of<SearchBloc>(context).searchResults;
        return Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.all(26.0),
          child: GroupedListView(
            collection: searchResults,
            groupBy: (SearchResult searchResult) =>
                searchResult.searchBackend[0].toUpperCase() +
                searchResult.searchBackend.substring(1),
            groupBuilder: (BuildContext context, String searchBackend) =>
                Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          searchBackend,
                          style: Theme.of(context).textTheme.headline4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Color.fromRGBO(48, 48, 51, 1),
                  ))
                ]),
              ],
            ),
            listBuilder: (BuildContext context, SearchResult searchResult) {
              Track track = searchResult.track;
              return ListTile(
                leading: BackendIcon(
                  track: track,
                  enableGesture: false,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      track.name,
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.getArtists(),
                      style: Theme.of(context).textTheme.headline2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () => close(context, track),
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _appData,
      builder: (context, appDataSnapshot) {
        SharedPreferences appData = appDataSnapshot?.data;
        List suggestionList = appData?.getStringList(_storageKey);
        return ListView.builder(
            shrinkWrap: true,
            itemCount: suggestionList?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  suggestionList[index],
                  style: Theme.of(context).textTheme.headline3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  query = suggestionList[index];
                  showResults(context);
                },
              );
            });
      },
    );
  }
}
