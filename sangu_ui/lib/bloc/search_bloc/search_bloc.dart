import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sangu/bloc/search_bloc/bloc.dart';
import 'package:sangu_websocket/sangu_websocket.dart' as SW;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SW.SanguWebSocket webSocket;
  StreamSubscription _streamSubscription;

  SearchBloc({this.webSocket});

  @override
  SearchState get initialState => NoSearchInProgress();

  List<SW.SearchResult> searchResults;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is LoadSearchEvents) {
      yield* _mapLoadSearchEventsToState(event);
    } else if (event is Search) {
      yield SearchResultsLoading();
      webSocket.search(event.query);
    } else if (event is ReceivedSearchResults) {
      searchResults = event.searchResults;
      yield SearchResultsReady();
    }
  }

  Stream<SearchState> _mapLoadSearchEventsToState(
      LoadSearchEvents event) async* {
    _streamSubscription?.cancel();
    _streamSubscription = webSocket.stream.listen((event) {
      if (event is SW.ReceivedSearchResults) {
        add(ReceivedSearchResults(searchResults: event.searchResults));
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
