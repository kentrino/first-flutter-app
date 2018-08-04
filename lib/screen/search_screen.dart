import "package:flutter/material.dart";

import "package:first_app/api/github_api.dart";
import "package:first_app/bloc/search_bloc.dart";
import "package:first_app/widget/search_result_widget.dart";

class SearchScreen extends StatefulWidget {
  // TODO: なぜここでblocを作ってしまわないの？
  final GithubApi api;

  SearchScreen({Key key, GithubApi api})
    : this.api = api ?? GithubApi(),
      super(key: key);

  @override
  SearchScreenState createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  SearchBloc bloc;

  @override
  void initState( ) {
    super.initState();
    // State<SearchScreen> はSearchScreenをプロパティwidgetとして内部にもつ
    bloc = SearchBloc(widget.api);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: wtf is StreamBuilder
    return StreamBuilder<SearchState>(
      stream: bloc.state$,
      initialData: SearchNoTerm(),
      // TODO: wtf is AsyncSnapshot
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        final state = snapshot.data;
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Flex(direction: Axis.vertical, children: <Widget>[
                // TODO: Flexの何かっぽい
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Github...",
                    ),
                    style: TextStyle(
                      fontSize: 36.0,
                      fontFamily: "Hind",
                      decoration: TextDecoration.none,
                    ),
                    // TODO: what is Sink#add
                    onChanged: bloc.term$.add,
                  ),
                ),
                // TODO: Flexの何かっぽい
                Expanded(
                    child: Stack(
                      children: <Widget>[
                        // TODO: SearchResultWidget, Loadingとか実装
                        SearchResultWidget(
                          items: state is SearchPopulated ? state.result.items : [],
                        )
                      ],
                    )
                )
              ])
            ],
          )
        );
      }
    );
  }
}
