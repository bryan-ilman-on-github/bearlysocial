import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/cloud_apis.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _AuthNotifier extends StateNotifier<bool> {
  _AuthNotifier() : super(false);

  void enterApp() => state = true;

  void exitApp() {
    LocalDatabaseUtility.emptyDatabase();
    state = false;
  }

  Future<void> validateToken() async {
    late String txnId, txnToken;

    [txnId, txnToken] = LocalDatabaseUtility.retrieveTransactions(
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

final _pod =
    StateNotifierProvider<_AuthNotifier, bool>((ref) => _AuthNotifier());

final appAuth = Provider((ref) => ref.watch(_pod));

final enterApp = Provider((ref) => ref.read(_pod.notifier).enterApp);

final exitApp = Provider((ref) => ref.read(_pod.notifier).exitApp);

final deleteAccount = Provider((ref) => ref.read(_pod.notifier).deleteAccount);
