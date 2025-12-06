import 'package:face2face/components/widgets/my_button.dart';
import 'package:face2face/components/widgets/my_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/authentication_bloc.dart';
import '../../../bloc/auth/authentication_event.dart';
import '../../../bloc/auth/authentication_state.dart';
import 'check_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

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

        if (!state.isLoading && state.error == null) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => CheckScreen(phone: phoneController.text),
            ),
          );
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 60),
                      DefaultTextStyle(
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 28,
                          color: Colors.black,
                        ),
                        child: const Text('Регистрация', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: MyTextField(
                          controller: phoneController,
                          placeholder: 'Введите номер телефона',
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            final regex = RegExp(r'^\+375\d{9}$');
                            if (value == null || !regex.hasMatch(value)) {
                              return 'Введите номер в формате +375XXXXXXXXX';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                    child: state.isLoading
                        ? const CupertinoActivityIndicator()
                        : MyButton(
                      onChange: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationBloc>().add(
                            AuthenticationSendPhoneRequested(phoneController.text),
                          );
                        }
                      },
                      buttonName: 'Отправить SMS',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
