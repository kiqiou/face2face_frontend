import 'package:face2face/services/user/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'bloc/auth/helper/helper.dart';
import 'bloc/auth/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
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
