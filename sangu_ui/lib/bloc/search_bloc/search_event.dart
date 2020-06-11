import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sangu_websocket/sangu_websocket.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class Search extends SearchEvent {
  final Map query;

  Search({this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => "Search { query: $query }";
}

class ReceivedSearchResults extends SearchEvent {
  final List<SearchResult> searchResults;

  ReceivedSearchResults({this.searchResults});

  @override
  List<Object> get props => [searchResults];

  @override
  String toString() =>
      "ReceivedSearchResults { # searchResults: ${searchResults.length} }";
}
