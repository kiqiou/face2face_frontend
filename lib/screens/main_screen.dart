import 'package:face2face/screens/profile/views/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../components/const/app_colors.dart';
import 'client/menu/views/menu_screen.dart';
import 'cosmetologist/appointment/appointment_screen.dart';
import 'cosmetologist/procedure/procedures__screen.dart';

final currentUserProvider = StateProvider<MyUser?>((ref) => null);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
   final List<BottomNavigationBarItem> tabs = [BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [MyColors.accent,
              Color(0xFFEDDAB5),],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const Icon(CupertinoIcons.home, color: CupertinoColors.white, size: 28),
      ),
      label: 'Запись',
    ),
        BottomNavigationBarItem(
    icon: ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [MyColors.accent,
            Color(0xFFEDDAB5),],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: const Icon(CupertinoIcons.person, color: CupertinoColors.white, size: 28),
    ),
    label: 'Профиль',
    ),
    ];

    late final List<Widget> pages =  [
      MenuScreen(),
      ProfileScreen(),
    ];

    // if (user.role == 2) {
    //   tabs = [
    //     BottomNavigationBarItem(
    //       icon: ShaderMask(
    //         shaderCallback: (bounds) {
    //           return const LinearGradient(
    //             colors: [Color(0xFFFFF8DC), Color(0xFFEACD76), Color(0xFFFFF8DC)],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //           ).createShader(bounds);
    //         },
    //         child: const Icon(CupertinoIcons.calendar, color: CupertinoColors.white, size: 28),
    //       ),
    //       label: 'Записи',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: ShaderMask(
    //         shaderCallback: (bounds) {
    //           return const LinearGradient(
    //             colors: [Color(0xFFFFF8DC), Color(0xFFEACD76), Color(0xFFFFF8DC)],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //           ).createShader(bounds);
    //         },
    //         child: const Icon(CupertinoIcons.plus, color: CupertinoColors.white, size: 28),
    //       ),
    //       label: 'Процедуры',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: ShaderMask(
    //         shaderCallback: (bounds) {
    //           return const LinearGradient(
    //             colors: [Color(0xFFFFF8DC), Color(0xFFEACD76), Color(0xFFFFF8DC)],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //           ).createShader(bounds);
    //         },
    //         child: const Icon(CupertinoIcons.person, color: CupertinoColors.white, size: 28),
    //       ),
    //       label: 'Профиль',
    //     ),
    //   ];
    //
    //   pages = [
    //     CosmetologistAppointmentsScreen(),
    //     CosmetologistProceduresScreen(),
    //     ProfileScreen(),
    //   ];
    // } else {

    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Manrope', color: CupertinoColors.black, fontSize: 20),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: CupertinoColors.white,
          items: tabs,
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(),
                child: SafeArea(child: pages[index]),
              );
            },
          );
        },
      ),
    );
  }
}