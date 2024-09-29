import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPageEmailAddressStateNotifier
    extends StateNotifier<String> {
  AuthenticationPageEmailAddressStateNotifier() : super('');

  void setState({
    required String emailAddr,
  }) {
    state = emailAddr;
  }
}

final authPageEmailAddrStateNotifierProvider =
    StateNotifierProvider<AuthenticationPageEmailAddressStateNotifier, String>(
  (ref) => AuthenticationPageEmailAddressStateNotifier(),
);

final authPageEmailAddr = Provider((ref) {
  return ref.watch(authPageEmailAddrStateNotifierProvider);
});

final setAuthPageEmailAddr = Provider((ref) {
  return ref.read(authPageEmailAddrStateNotifierProvider.notifier).setState;
});
