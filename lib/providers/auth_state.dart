import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/endpoint.dart';
import 'package:bearlysocial/utilities/api.dart';
import 'package:bearlysocial/utilities/db_operation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class AuthenticationStateNotifier extends StateNotifier<bool> {
  AuthenticationStateNotifier() : super(false);

  void enterApp() {
    state = true;
  }

  void exitApp() {
    DatabaseOperation.emptyDatabase();
    state = false;
  }

  Future<void> validateToken() async {
    late String txnId, txnToken;

    [txnId, txnToken] = DatabaseOperation.retrieveTransactions(
      keys: [
        DatabaseKey.id.name,
        DatabaseKey.token.name,
      ],
    );

    final Response httpResponse = await API.makeRequest(
      endpoint: Endpoint.validateToken,
      body: {'id': txnId, 'token': txnToken},
    );

    if (httpResponse.statusCode == 200) {
      enterApp();
    } else {
      exitApp();
    }
  }
}

final authenticationStateNotifierProvider =
    StateNotifierProvider<AuthenticationStateNotifier, bool>(
  (ref) => AuthenticationStateNotifier(),
);

final auth = Provider((ref) {
  return ref.watch(authenticationStateNotifierProvider);
});

final enterApp = Provider((ref) {
  return ref.read(authenticationStateNotifierProvider.notifier).enterApp;
});

final exitApp = Provider((ref) {
  return ref.read(authenticationStateNotifierProvider.notifier).exitApp;
});

final validateToken = Provider((ref) {
  return ref.read(authenticationStateNotifierProvider.notifier).validateToken;
});
