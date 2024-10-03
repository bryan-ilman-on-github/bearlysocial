import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/cloud_apis.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationStateNotifier extends StateNotifier<bool> {
  AuthenticationStateNotifier() : super(false);

  void enterApp() {
    state = true;
  }

  void exitApp() {
    LocalDB.emptyDatabase();
    state = false;
  }

  Future<void> validateToken() async {
    late String txnId, txnToken;

    [txnId, txnToken] = LocalDB.retrieveTransactions(
      keys: [DatabaseKey.id.name, DatabaseKey.token.name],
    );

    final response = await AmazonWebServicesLambdaAPI.postRequest(
      endpoint: AmazonWebServicesLambdaEndpoints.validateToken,
      body: {'id': txnId, 'token': txnToken},
    );

    if (response.statusCode == 200) {
      enterApp();
    } else {
      exitApp();
    }
  }

  Future<void> deleteAccount() async {
    late String txnId, txnToken;

    [txnId, txnToken] = LocalDB.retrieveTransactions(
      keys: [
        DatabaseKey.id.name,
        DatabaseKey.token.name,
      ],
    );

    final response = await AmazonWebServicesLambdaAPI.postRequest(
      endpoint: AmazonWebServicesLambdaEndpoints.deleteAccount,
      body: {'id': txnId, 'token': txnToken},
    );

    if (response.statusCode == 200) {
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

final deleteAccount = Provider((ref) {
  return ref.read(authenticationStateNotifierProvider.notifier).deleteAccount;
});
