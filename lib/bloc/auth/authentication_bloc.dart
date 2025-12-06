
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/user/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationSendPhoneRequested>(_onSendPhoneRequested);
    on<AuthenticationConfirmCodeRequested>(_onConfirmCodeRequested);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSendPhoneRequested(
      AuthenticationSendPhoneRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(const AuthenticationState.loading());
    try {
      await userRepository.sendPhone(event.phone);
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(AuthenticationState.unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onConfirmCodeRequested(
      AuthenticationConfirmCodeRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(const AuthenticationState.loading());
    try {
      final user = await userRepository.confirmCode(event.phone, event.code);
      if (user != null) {
        emit(AuthenticationState.authenticated(user));
      } else {
        emit(const AuthenticationState.unauthenticated(error: 'Ошибка подтверждения'));
      }
    } catch (e) {
      emit(AuthenticationState.unauthenticated(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    await userRepository.logoutUser();
    emit(const AuthenticationState.unauthenticated());
  }
}
