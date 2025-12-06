import '../../models/user.dart';

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class SendPhoneRequested extends AuthenticationEvent {
  final String phone;
  SendPhoneRequested(this.phone);
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationSendPhoneRequested extends AuthenticationEvent {
  final String phone;
  AuthenticationSendPhoneRequested(this.phone);
}

class AuthenticationConfirmCodeRequested extends AuthenticationEvent {
  final String phone;
  final String code;
  AuthenticationConfirmCodeRequested({required this.phone, required this.code});
}