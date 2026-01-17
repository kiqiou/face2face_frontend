import 'package:face2face/screens/splash_screen.dart';
import 'package:face2face/services/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'bloc/auth/helper/helper.dart';
import 'bloc/auth/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    final userRepository = UserRepository(
      authStorage: AuthStorage(),
    );

    runApp(
      ProviderScope(
        child: BlocProvider(
          create: (_) => AuthenticationBloc(userRepository: userRepository),
          child: MyApp(userRepository: userRepository),
        ),
      ),
    );
  });
}
