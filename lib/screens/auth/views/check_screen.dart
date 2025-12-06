import 'dart:async';

import 'package:face2face/components/widgets/my_button.dart';
import 'package:face2face/components/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/authentication_bloc.dart';
import '../../../bloc/auth/authentication_event.dart';
import '../../../bloc/auth/authentication_state.dart';
import '../../main_screen.dart';

class CheckScreen extends StatefulWidget {
  final String phone;

  const CheckScreen({super.key, required this.phone});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.error != null) {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text('Ошибка'),
              content: Text(state.error!),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Ок'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }

        if (state.user != null) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => const MainScreen()),
          );
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  color: CupertinoColors.black,
                  fontSize: 20
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 60),
                       Text('Отправлен 6-значный код по SMS'),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: MyTextField(
                            controller: codeController,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final regex = RegExp(r'^\d{6}$');
                              if (value == null || !regex.hasMatch(value)) {
                                return 'Введите 6-значный код';
                              }
                              return null;
                            }, placeholder:'Введите код',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _canResend ?
                          TextButton(
                            onPressed: () {
                              _startTimer();
                              context.read<AuthenticationBloc>().add(
                                AuthenticationSendPhoneRequested(widget.phone),
                              );
                            },
                              child: Text('Отправить повторно'))
                            : Text(
                              _canResend
                                  ? 'Вы можете отправить код повторно'
                                  : 'Повторная отправка через $_secondsRemaining сек.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 50,
                      ),
                      child: state.isLoading
                          ? const CupertinoActivityIndicator()
                          : MyButton(
                              onChange: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthenticationBloc>().add(
                                    AuthenticationConfirmCodeRequested(
                                      phone: widget.phone,
                                      code: codeController.text,
                                    ),
                                  );
                                }
                              },
                              buttonName: 'Подтвердить код',
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
