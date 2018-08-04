import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;

class GithubApi {
  final String baseUrl;
  final Map<String, SearchResult> cache;
  final http.Client client;

  GithubApi({
    HttpClient client,
    Map<String, SearchResult> cache,
    this.baseUrl = "https://api.gihub.com/search/repositories?q=",
  }) : this.client = client ?? http.Client(),
       this.cache = cache ?? <String, SearchResult>{};

  Future<SearchResult> search(String term) async {
    if (cache.containsKey(term)){
      return cache[term];
    } else {
      final result = await _fetchResults(term);
      cache[term] = result;
      return result;
    }
  }

  Future<SearchResult> _fetchResults(String term) async {
    final response = await client.get(Uri.parse("$baseUrl$term"));
    final results = json.decode(response.body);
    return SearchResult.fromJson(results["items"]);
  }
}

class SearchResult {
  final List<SearchResultItem> items;

  SearchResult(this.items);

  factory SearchResult.fromJson(dynamic json) {
    // TODO: wtf is this cast?
    final items = (json as List)
        .cast<Map<String, Object>>()
        .map((Map<String, Object> item) {
          return SearchResultItem.fromJson(item);
    }).toList();

    return SearchResult(items);
  }

  bool get isPopulated => items.isNotEmpty;
  bool get isEmpty => items.isEmpty;
}

class SearchResultItem {
  final String fullName;
  final String url;
  final String avatarUrl;

  // constructor?
  SearchResultItem(this.fullName, this.url, this.avatarUrl);

  // TODO: wtf is factory
  factory SearchResultItem.fromJson(Map<String, Object> json) {
    return SearchResultItem(
      json["full_name"] as String,
      json["html_url"] as String,
      (json["owner"] as Map<String, Object>)["avatar_url"] as String
    );
  }
}
