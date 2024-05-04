import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPageEmailAddressStateNotifier
    extends StateNotifier<String> {
  AuthenticationPageEmailAddressStateNotifier() : super('');

  void setState({
    required String emailAddress,
  }) {
    state = emailAddress;
  }
}

final authenticationPageEmailAddressStateNotifierProvider =
    StateNotifierProvider<AuthenticationPageEmailAddressStateNotifier, String>(
  (ref) => AuthenticationPageEmailAddressStateNotifier(),
);

final authenticationPageEmailAddress = Provider((ref) {
  return ref.watch(authenticationPageEmailAddressStateNotifierProvider);
});

final setAuthenticationPageEmailAddress = Provider((ref) {
  return ref
      .read(authenticationPageEmailAddressStateNotifierProvider.notifier)
      .setState;
});
