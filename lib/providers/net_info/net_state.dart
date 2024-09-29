import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/cloud_details.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/local_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkStateNotifier extends StateNotifier<bool> {
  NetworkStateNotifier() : super(false);

  Future<void> storeNetworkInfo() async {}
}

final NetworkStateNotifierProvider =
    StateNotifierProvider<NetworkStateNotifier, bool>(
  (ref) => NetworkStateNotifier(),
);

final network = Provider((ref) {
  return ref.watch(NetworkStateNotifierProvider);
});

final storeNetworkInfo = Provider((ref) {
  return ref.read(NetworkStateNotifierProvider.notifier).storeNetworkInfo;
});
