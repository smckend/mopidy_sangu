import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/search_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SW.SanguWebSocket webSocket;

  SearchBloc({this.webSocket}) : super(NoSearchInProgress());

  List<SW.SearchResult> searchResults;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is Search) {
      yield SearchResultsLoading();
      webSocket.search(event.query);
    } else if (event is ReceivedSearchResults) {
      searchResults = event.searchResults;
      yield SearchResultsReady();
    }
  }
}
