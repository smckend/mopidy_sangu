import 'track.dart';

class SearchResult {
  SearchResult({
    this.track,
    this.searchBackend,
  });

  Track track;
  String searchBackend;

  @override
  String toString() {
    return 'SearchResult { track: $track, searchBackend: $searchBackend }';
  }
}
