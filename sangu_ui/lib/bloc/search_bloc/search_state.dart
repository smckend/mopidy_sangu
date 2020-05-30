import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class NoSearchInProgress extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchResultsLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchResultsReady extends SearchState {
  @override
  List<Object> get props => [];
}
