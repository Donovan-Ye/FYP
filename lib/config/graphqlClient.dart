import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlClient {
  static final _uri = 'http://192.168.0.150:4000/graphql';

  static GraphQLClient getNewClient() {
    final client =
        GraphQLClient(cache: InMemoryCache(), link: HttpLink(uri: _uri));
    return client;
  }
}
