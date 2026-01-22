
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id.toString());
        await prefs.setString('username', user.username);
        if (user.cosmetologistId != null) {
          await prefs.setString('cosmetologist_id', user.cosmetologistId.toString());
          print('✅ Cosmetologist ID: ${user.cosmetologistId}');
        } else {
          print('ℹ️ Cosmetologist профиль отсутствует');
        }
      }
    } catch (e) {
      print('❌ Ошибка: $e');
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
