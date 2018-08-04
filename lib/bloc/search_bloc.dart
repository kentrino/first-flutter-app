import "dart:async";

import "package:rxdart/rxdart.dart";

import "package:first_app/api/github_api.dart";

// 圏
// 名前が仰々しい。もう少し良い名前はないのか
class SearchBloc {
  // Sinkのインターフェース
  final Sink<String> term$;
  final Stream<SearchState> state$;

  // コンポジション
  factory SearchBloc(GithubApi api) {
    // TODO: Got error: Close instance of `dart.Core.Sink`
    final term$ = PublishSubject<String>();

    final state$ = term$
      .distinct()
      // Wait for the user to stop typing for 250ms before running a search
      .debounce(const Duration(milliseconds: 250))
      .switchMap<SearchState>((String term) => _search(term, api))
      .startWith(SearchNoTerm());
    return SearchBloc._(term$, state$);
  }

  SearchBloc._(this.term$, this.state$);

  void dispose() {
    term$.close();
  }

  static Stream<SearchState> _search(String term, GithubApi api) async* {
    if (term.isEmpty) {
      yield SearchNoTerm();
    } else {
      // TODO: どう挙動するのか後ほど調べる
      yield  SearchLoading();

      try {
        final result = await api.search(term);
        if (result.isEmpty) {
          yield SearchEmpty();
        } else {
          yield SearchPopulated(result);
        }
      } catch (e) {
        yield SearchError();
      }
    }
  }
}

class SearchState {}
class SearchLoading extends SearchState {}
class SearchError extends SearchState {}
class SearchNoTerm extends SearchState {}
class SearchPopulated extends SearchState {
  final SearchResult result;
  SearchPopulated(this.result);
}
class SearchEmpty extends SearchState {}
