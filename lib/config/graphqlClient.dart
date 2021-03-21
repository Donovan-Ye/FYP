import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphqlClient {
  static final _uri = env['API_SERVER'] + "/graphql";

  static GraphQLClient getNewClient() {
    final client =
        GraphQLClient(cache: InMemoryCache(), link: HttpLink(uri: _uri));
    return client;
  }
}
