import '../../models/user.dart';

class AuthenticationState {
  final MyUser? user;
  final bool isLoading;
  final String? error;

  const AuthenticationState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthenticationState.unknown() : this();

  const AuthenticationState.loading() : this(isLoading: true);

  const AuthenticationState.authenticated(MyUser user)
      : this(user: user, isLoading: false);

  const AuthenticationState.unauthenticated({String? error})
      : this(user: null, isLoading: false, error: error);
}
