import 'package:graphql/client.dart';

import 'users.dart';
import 'repositories.dart';

GraphQLClient _client(token) {
  final HttpLink _httpLink = HttpLink(uri: 'https://api.github.com/graphql');

  final AuthLink _authLink = AuthLink(getToken: () => '$token');

  final Link _link = _authLink.concat(_httpLink);

  return GraphQLClient(
    cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    link: _link,
  );
}

GraphQLClient _innerClient;

initClient(token) {
  _innerClient ??= _client(token);
}

releaseClient() {
  _innerClient = null;
}

Future<QueryResult> getRepository(String owner, String name) async {
  final QueryOptions _options = QueryOptions(
    documentNode: gql(readRepository),
    variables: <String, dynamic>{
      'owner': owner,
      'name': name,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  return await _innerClient.query(_options);
}

Future<QueryResult> getTrendUser(String location, {String cursor}) async {
  var variables = cursor == null
      ? <String, dynamic>{
          'location': 'location:$location sort:followers',
        }
      : <String, dynamic>{
          'location': 'location:$location sort:followers',
          'after': cursor,
        };

  final QueryOptions _options = QueryOptions(
    documentNode: cursor == null ? gql(readTrendUser) : gql(readTrendUserByCursor),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );

  return await _innerClient.query(_options);
}
